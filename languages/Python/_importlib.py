#!/usr/bin/env python3
import os, inspect, importlib
from pathlib import Path
from typing import Optional


#### 1. call module by nam
assert(importlib.util.find_spec("pandas") is not None)
version = importlib.metadata.version('pandas')

print(f"pandas: {version}")


#### 2. call module by path
module_dir = str(Path("src")).replace(os.sep, '.')
module_file = "utils.py"

module = importlib.import_module(f"{module_dir}.{module_file[:-3]}")

hello = getattr(module, "hello")

hello()


#### 3. signature of functions
def hello(name: Optional[str]):
    print(f"Hello, {name}!")

sig = inspect.signature(hello)
print(f"~~~ signature of hello: {sig}")


#### 4. read a file directly
# ls data/tests/message.txt
text = importlib.resources.files("data.tests").joinpath("message.txt").read_text(encoding="utf-8")
# .read_bytes()
