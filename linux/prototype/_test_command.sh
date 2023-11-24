#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

cmd=$1

>&2 echo "==> test command: $cmd"

if [ $(command -v "$cmd") ]; then
    echo "YES"
else
    echo "NO"
fi

>&2 echo "==> exit"
