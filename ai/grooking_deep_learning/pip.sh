#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


pip install -r requirements.txt

exit
pip install ipython

pip install numpy
