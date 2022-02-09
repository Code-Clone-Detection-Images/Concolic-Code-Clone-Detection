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
from __future__ import annotations # allows to defer annotations in same class etc.

import csv
import re

from typing import Dict, Set, Tuple

class MethodDiff:
   """The csv contains 'a-b: x' sequences. This class holds the two compared methods 'a' and 'b'
      to compare them order-agnostic
      TODO: we have to include the files in the matching!!!!!!
   """
   # we first try to match ':' if it does not work we try to match '.'
   string_regex = re.compile(r"([^:]*:|[^.]*\.)(?P<a>[^-]+)-([^:]*:|[^.]*\.)(?P<b>.+)")

   def __init__(self, method_a: str, method_b: str):
      # sort the strings
      self.method_a, self.method_b = (method_a, method_b) if method_a < method_b else (method_b, method_a)

   def __eq__(self, other: MethodDiff) -> bool:
      # we could sort them etc. but
      return other.method_a == self.method_a and other.method_b == self.method_b

   def __hash__(self) -> int:
      return hash((self.method_a, self.method_b)) # uses sorting from init!

   def __str__(self) -> str:
      return f"{{{self.method_a}, {self.method_b}}}"

   @classmethod
   def parse(cls, str: str) -> MethodDiff:
      match = MethodDiff.string_regex.match(str)
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
      reader = csv.DictReader(f, delimiter=',',quotechar='"') # we have no language using '"' in funcnames
      # assert fieldnames:
      assert reader.fieldnames[0] == "Files"
      assert reader.fieldnames[1] == "LevenDist" or "LevenDistance"

      for row in reader:
         # TODO: make keys more flexible
         method_diff = MethodDiff.parse(row[reader.fieldnames[0]])
         data[method_diff] = float(row[reader.fieldnames[1]])

   return data


def compare(expected: LevenDistMapping, got: LevenDistMapping) -> LevenDistSet:
   """uses set mechanics to identify differences. returns differences
   """
   a = set(expected.items())
   b = set(got.items())
   return a ^ b # symmetric difference



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
      print(f"[ERROR] Differences [currently, shows symmetric differences of expected ^ got]:")
      for i, elem in enumerate(cmp):
         print(str(i) + ')', elem[0], elem[1])
      exit(2)