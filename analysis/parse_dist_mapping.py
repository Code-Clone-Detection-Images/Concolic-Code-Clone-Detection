# https://stackoverflow.com/questions/42845972/typed-python-using-the-classes-own-type-inside-class-definition
# allows to defer annotations in same class etc.
from __future__ import annotations

import csv
import re

from typing import Dict, Set, Tuple


class UnknownClassName(Exception):
    pass


class MethodDiff:
    """The csv contains 'a-b: x' sequences. This class holds the two compared methods 'a' and 'b'
       to compare them order-agnostic
    """
    # we first try to match ':' if it does not work we try to match '.'
    # Note: i try to adapt the given information a little bit
    string_regex = re.compile(r"(?P<fa>[^:]*:|[^.]*\.)(?P<a>[^-]+)-(?P<fb>[^:]*:|[^.]*\.)(?P<b>.+)")

    def __init__(self, method_a: str, method_b: str):
        # sort the strings
        self.method_a, self.method_b = (method_a, method_b) if method_a < method_b else (method_b, method_a)

    def __eq__(self, other: object) -> bool:
        # we could sort them etc. but
        return type(other) == MethodDiff and other.method_a == self.method_a and other.method_b == self.method_b

    def __hash__(self) -> int:
        return hash((self.method_a, self.method_b))  # uses sorting from init!

    def __str__(self) -> str:
        return f"{{{self.method_a}, {self.method_b}}}"

    @classmethod
    def parse(cls, str: str) -> MethodDiff:
        match = MethodDiff.string_regex.match(str)
        if match is None:
            raise UnknownClassName
        left_func = match.group('fa')[:-1].strip()
        right_func = match.group('fb')[:-1].strip()
        return MethodDiff(f"{left_func}.{match.group('a')}", f"{right_func}.{match.group('b')}")


LevenDist = float
LevenDistMapping = Dict[MethodDiff, LevenDist]
LevenDistSet = Set[Tuple[MethodDiff, LevenDist]]


def load_leven_dist_mapping(filepath: str) -> LevenDistMapping:
    """reads the csv given with [filepath] and produces a format agnostic mapping of it
    """
    data = {}

    with open(filepath, 'r') as f:
        # we have no language using '"' in funcnames
        reader = csv.DictReader(f, delimiter=',', quotechar='"')
        # assert fieldnames:
        assert reader.fieldnames is not None and len(reader.fieldnames) == 2, "there should by only 2 fields in the csv"
        first = reader.fieldnames[0]
        assert first == "Files"
        levenshtein = reader.fieldnames[1]
        assert levenshtein in ["LevenDist", "LevenDistance"]

        for row in reader:
            method_diff = MethodDiff.parse(row[first])
            data[method_diff] = float(row[levenshtein])

    return data
