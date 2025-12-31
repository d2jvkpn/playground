#!/usr/bin/env python3
# path: <VENV>/lib/python3.12/site-packages/sitecustomize.py
import sys

dist = sys.prefix + "/lib/python3.12/dist-packages" # or a custom place

if dist in sys.path:
    sys.path.remove(dist)

sys.path.insert(0, dist)
