#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


#### venv
if [ ! -d "$HOME/apps/venv" ]; then
    python3 -m venv "$HOME/apps/venv"
fi

#### npm
mkdir -p "$HOME/apps/npm"
npm config set prefix "$HOME/apps/npm"
# npm install -g http-server
