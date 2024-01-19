#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# jf=$1
key=${key:-links}

function download() {
    name=$1
    link=$2

    [ -f $name ] && continue
    wget -O "$name.temp" $link
    mv "$name.temp" "$name"
}

export -f download

for jf in "$@"; do
    n=0
    for link in $(jq -r ".$key[]" $jf); do
        n=$((n+1))
        name=$(basename $link)
        name=$(dirname $jf)/$(printf "%03d_%s" $n $name)
        # wget -cO $name $link
     done
done | xargs -n 2 -P 8 bash -c 'download "$@"' _

exit
for jf in "$@"; do
    n=0
    for link in $(jq -r ".$key[]" $jf); do
        n=$((n+1))
        name=$(basename $link)
        name=$(dirname $jf)/$(printf "%03d_%s" $n $name)
        # wget -cO $name $link
     done
done | xargs -n 2 -P 8 wget -O
