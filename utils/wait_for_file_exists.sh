#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# target=/data/ok
target=$1

echo "==> checking file $target"
until [ ! -f $target ]; do
    # echo ">>> $(date +%FT%T%z) file not exists: /data/ok"
    sleep 1 && echo -n "."
done
echo ""
echo "==> file exists $target"
