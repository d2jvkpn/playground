#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

if [ -s  requirements.txt ]; then
    pip install -r requirements.txt
else
    pip install ipython
    pip install numpy keras tensorflow polars
    pip3 freeze > requirements.txt
fi
