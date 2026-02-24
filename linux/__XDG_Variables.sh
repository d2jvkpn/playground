#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


export XDG_DATA_HOME=~/.local/share
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_STATE_HOME=~/.local/state
export XDG_RUNTIME_DIR=/run/user/$UID
