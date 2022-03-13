#!/usr/bin/env python3

from parse_dist_mapping import LevenDistMapping, load_leven_dist_mapping
from typing import List


def print_clone_type(mapping: LevenDistMapping, clone_type: int, leven_range: List[int]) -> int:
    """Returns the number of clones of this type detected"""
    counter = 0
    print("  - type", clone_type)
    for diff, leven in mapping.items():
        if leven in leven_range:
            print("    -", diff, f"[{leven}]")
            counter += 1
    return counter


if __name__ == '__main__':
    import sys
    if len(sys.argv) != 2:
        print(f"usage: {sys.argv[0]} <mapping.csv>")
        exit(1)
    mapping = load_leven_dist_mapping(sys.argv[1])
    t1 = print_clone_type(mapping, 1, list(range(0, 11)))
    t2 = print_clone_type(mapping, 2, list(range(10, 21)))
    t3 = print_clone_type(mapping, 3, list(range(20, 31)))
    t4 = print_clone_type(mapping, 4, list(range(30, 41)))

    print("  - others")
    other = 0
    for diff, leven in mapping.items():
        if leven > 40:
            other += 1
            print("    -", diff, f"[{leven}]")

    print("======= Clones ======= ")
    print(f"Type-1: {t1}\nType-2: {t2}\nType-3: {t3}\nType-4: {t4}")
    print(f"Others: {other}")
