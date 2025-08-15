#!/usr/bin/env python3
from pathlib import Path


checkpoints = sorted(
    Path("data/pricer-20250813").glob("checkpoint-*/"),
    key=lambda x: x.stat().st_ctime,
    #key=lambda x: x.stat().st_mtime,
    #key=lambda x: int(x.name.split("-")[1]),
    reverse=True,
)

print("--> checkpoints: {checkpoints}")
