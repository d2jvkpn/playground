#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# target=/data/ok
target=$1

echo "==> checking file $target"

n=0
until [ ! -f $target ]; do
    # echo ">>> $(date +%FT%T%z) file not exists: /data/ok"
    sleep 1 && echo -n "."

    n=$((n+1))
    [ $((n % 60 )) == 0 ] && echo ""
done
echo ""

echo "==> file exists $target"
