#!/usr/bin/env python3
import os
from pathlib import Path
_wd, _path = os.getcwd(), Path(os.sys.argv[0]).resolve().parent
os.sys.path.append(os.getenv("PROJECT_DIR") or _wd)
#os.environ['ANSWER'] = "42"
