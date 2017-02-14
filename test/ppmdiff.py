# coding: utf-8

import os
import sys

ppm = sys.argv[1] + '.ppm'
rt = open(os.path.join('ppm', 'rt', ppm)).readlines()[2:]
sim = open(os.path.join('ppm', 'sim', ppm)).readlines()[2:]

print("""P3
128 128 255""")
for (r, s) in zip(rt, sim):
    if r != s:
        print(r, end="")
    else:
        print("0 0 0")
