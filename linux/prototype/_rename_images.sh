#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

n=0
for f in $(ls *.jpg); do
    n=$((n+1))
    name=$(printf "p%03d.jpg" $n)
    mv $f $name
done
