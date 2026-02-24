#!/usr/bin/env python3
import os
import importlib.metadata as md

pkgs = ["torch", "torchaudio", "torchvision"]
pkgs.extend(os.sys.argv[1:])

for p in pkgs:
    try:
        print(f"{p}=={md.version(p)}")
    except md.PackageNotFoundError:
        pass
