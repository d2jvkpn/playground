#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


cmd=$1

>&2 echo "==> test command: $cmd"

if [ $(command -v "$cmd") ]; then
    echo "YES"
else
    echo "NO"
fi

>&2 echo "==> exit"
