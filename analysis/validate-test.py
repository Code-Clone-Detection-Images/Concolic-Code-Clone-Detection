#!/usr/bin/env python3

# sadly, there are a lot of problems with using the "prepared and expected" results of kraw.c found at
# https://web.archive.org/web/20220209105753/http://www.se.rit.edu/~dkrutz/CCCD/pages/results/kraw.html
# [interestingly i had to archive this page]

# There are several problems:
# 1. while the information is the same, the files are named differently: kraw_try1 vs. kraw.c in the output
# 2. the expected page show integers, the output uses floats.
# 3. the mappings do not appear to be in order! Sometimes there is 'sumprod3a[..]-[..]sumprod1b' and sometimes
#    it is the other way around (still with the same levendistance)

from parse_dist_mapping import LevenDistMapping, LevenDistSet, load_leven_dist_mapping


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
    expected = load_leven_dist_mapping(sys.argv[1])
    got = load_leven_dist_mapping(sys.argv[2])
    cmp = compare(expected, got)
    if len(cmp) == 0:
        print('passed the test!')
        exit(0)
    else:
        print("[ERROR] Differences [symmetric: expected ^ got]:")
        for i, elem in enumerate(cmp):
            print(str(i) + ')', elem[0], elem[1])
        exit(2)
