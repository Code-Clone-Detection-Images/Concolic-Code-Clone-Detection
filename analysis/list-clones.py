#!/usr/bin/env python3

# sadly, there are a lot of problems with using the "prepared and expected" results of kraw.c found at
# https://web.archive.org/web/20220209105753/http://www.se.rit.edu/~dkrutz/CCCD/pages/results/kraw.html
# [interestingly i had to archive this page]

# There are several problems:
# 1. while the information is the same, the files are named differently: kraw_try1 vs. kraw.c in the output
# 2. the expected page show integers, the output uses floats.
# 3. the mappings do not appear to be in order! Sometimes there is 'sumprod3a[..]-[..]sumprod1b' and sometimes
#    it is the other way around (still with the same levendistance)

from parse_dist_mapping import LevenDistMapping, load_leven_dist_mapping
from typing import List


def print_clone_type(mapping: LevenDistMapping, clone_type: int, leven_range: List[int]) -> None:
    print("  - type", clone_type)
    for diff, leven in mapping.items():
        if leven in leven_range:
            print("    -", diff, f"[{leven}]")


if __name__ == '__main__':
    import sys
    if len(sys.argv) != 2:
        print(f"usage: {sys.argv[0]} <mapping.csv>")
        exit(1)
    mapping = load_leven_dist_mapping(sys.argv[1])
    print_clone_type(mapping, 1, list(range(0, 11)))
    print_clone_type(mapping, 2, list(range(10, 21)))
    print_clone_type(mapping, 3, list(range(20, 31)))
    print_clone_type(mapping, 4, list(range(30, 41)))

    print("  - others")
    for diff, leven in mapping.items():
        if leven > 40:
            print("    -", diff, f"[{leven}]")
