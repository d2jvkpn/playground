#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# jf=$1
key=${key:-links}

for jf in "$@"; do
    n=0
    for link in $(jq -r ".$key[]" $jf); do
        n=$((n+1))
        name=$(basename $link)
        name=$(dirname $jf)/$(printf "%03d_%s" $n $name)
     done
done | xargs -n 2 -P 8 wget -cO
