#!/usr/bin/env python3

# sadly, there are a lot of problems with using the "prepared and expected" results of kraw.c found at
# https://web.archive.org/web/20220209105753/http://www.se.rit.edu/~dkrutz/CCCD/pages/results/kraw.html
# [interestingly i had to archive this page]

# There are several problems:
# 1. while the information is the same, the files are named differently: kraw_try1 vs. kraw.c in the output
# 2. the expected page show integers, the output uses floats.
# 3. the mappings do not appear to be in order! Sometimes there is 'sumprod3a[..]-[..]sumprod1b' and sometimes
#    it is the other way around (still with the same levendistance)

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
       TODO: we have to include the files in the matching!!!!!!
    """
    # we first try to match ':' if it does not work we try to match '.'
    string_regex = re.compile(
        r"([^:]*:|[^.]*\.)(?P<a>[^-]+)-([^:]*:|[^.]*\.)(?P<b>.+)")

    def __init__(self, method_a: str, method_b: str):
        # sort the strings
        self.method_a, self.method_b = (
            method_a, method_b) if method_a < method_b else (method_b, method_a)

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
        return MethodDiff(match.group('a'), match.group('b'))


LevenDistMapping = Dict[MethodDiff, float]
LevenDistSet = Set[Tuple[MethodDiff, float]]


def load_csv(filepath: str) -> LevenDistMapping:
    """reads the csv and produces a format agnostic mapping of

    Args:
        filepath (str): [description]

    Returns:
        Dict[str, float]: [description]
    """
    data = {}

    with open(filepath, 'r') as f:
        # we have no language using '"' in funcnames
        reader = csv.DictReader(f, delimiter=',', quotechar='"')
        # assert fieldnames:
        assert reader.fieldnames is not None and len(
            reader.fieldnames) == 2, "there should by only 2 fields in the csv"
        first = reader.fieldnames[0]
        assert first == "Files"
        levenshtein = reader.fieldnames[1]
        assert levenshtein in ["LevenDist", "LevenDistance"]

        for row in reader:
            method_diff = MethodDiff.parse(row[first])
            data[method_diff] = float(row[levenshtein])

    return data


def compare(expected: LevenDistMapping, got: LevenDistMapping) -> LevenDistSet:
    """uses set mechanics to identify differences. returns differences
    """
    a = set(expected.items())
    b = set(got.items())
    return a ^ b  # symmetric difference


if __name__ == '__main__':
    import sys
    if len(sys.argv) != 3:
        print(f"usage: {sys.argv[0]} <expected.csv> <got.csv>")
        exit(1)
    expected = load_csv(sys.argv[1])
    got = load_csv(sys.argv[2])
    cmp = compare(expected, got)
    if len(cmp) == 0:
        print('passed the test!')
        exit(0)
    else:
        print("[ERROR] Differences [symmetric: expected ^ got]:")
        for i, elem in enumerate(cmp):
            print(str(i) + ')', elem[0], elem[1])
        exit(2)
