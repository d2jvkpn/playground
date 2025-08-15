#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


pipx install uv

uv pip install -r pip.txt

uv lock
