#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit

python3 -c "import os; print(os.sys.path)"
#''
#/usr/lib/python312.zip
#/usr/lib/python3.12
#/usr/lib/python3.12/lib-dynload
#/opt/venv/lib/python3.12/site-packages

python3 -c "import site; print(site.getsitepackages())"
#/opt/venv/lib/python3.12/site-packages
#/opt/venv/local/lib/python3.12/dist-packages
#/opt/venv/lib/python3/dist-packages
#/opt/venv/lib/python3.12/dist-packages

pip install --no-cache-dir -r requirements.txt \
  --target /opt/venv/local/lib/python3.12/dist-packages


python3 -c "import sys,site,importlib.util; print(sys.executable); print(sys.prefix); print(site.getsitepackages()); print(importlib.util.find_spec('sitecustomize')); print(sys.path[:8])"


python3 -c "import sitecustomize; print(sitecustomize.__file__)"
