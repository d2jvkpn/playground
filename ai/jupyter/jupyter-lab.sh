#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

. .venv/bin/activate
. configs/local.env

export JUPYTER_TOKEN=$JUPYTER_TOKEN

jupyter lab --no-browser --allow-root --ip=0.0.0.0 --port=8888
