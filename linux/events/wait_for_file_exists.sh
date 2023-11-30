#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# target=/data/ok
target=$1
retries=${2:-300}

echo "==> checking file $target"

n=0
until [ ! -f $target ]; do
    # echo ">>> $(date +%FT%T%z) file not exists: /data/ok"
    sleep 1 && echo -n "."

    n=$((n+1)); [ $((n%60)) == 0 ] && echo ""

    [[ $retries -gt 0 && $n -gt "$retries" ]] && { >&2 echo "file not exists: $target"; exit 1; }
done
echo ""

echo "==> found file $target"
