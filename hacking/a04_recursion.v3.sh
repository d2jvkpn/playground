#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

if [ $# -eq 0 ]; then
    :
elif [ $# -eq 1 ]; then
    cd "$1"
else
    for d in "$@"; do
        bash "$0" "$d"
    done
    exit 0
fi

pwd
