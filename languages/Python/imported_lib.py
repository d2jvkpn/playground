#!/usr/bin/env python3
import os, importlib
from pathlib import Path


#### 1.
assert(importlib.util.find_spec("pandas") is not None)
version = importlib.metadata.version('pandas')

print(f"pandas: {version}")

#### 2. 
module_dir = str(Path("src")).replace(os.sep, '.')
module_file = "utils.py"

module = importlib.import_module(f"{module_dir}.{module_file[:-3]}")

hello = getattr(module, "hello")

hello()
