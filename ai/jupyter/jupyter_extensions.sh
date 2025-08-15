#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


uv pip install jupyterlab-execute-time

uv pip install bash_kernel
python -m bash_kernel.install
