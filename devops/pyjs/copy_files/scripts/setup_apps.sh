#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


if [ ! -d "$HOME/apps/venv" ]; then
    python3 -m venv "$HOME/apps/venv"
fi

mkdir -p "$HOME/apps/npm"

# npm config set prefix "$HOME/apps/npm"
# npm install -g http-server
# npm config get prefix
export NPM_CONFIG_PREFIX=$HOME/apps/npm

