#!/usr/bin/env python3

import os

py = os.path.abspath(os.sys.argv[0])
project = os.path.dirname(py)
app = os.path.basename(project)
print(py, project, app)
