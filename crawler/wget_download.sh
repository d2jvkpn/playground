#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# export http_proxy=socks://127.0.0.1:1081 https_proxy=socks://127.0.0.1:1081
# jq -r .links[] scrap_*.json | xargs -n 1 -P 8 -i wget -c {}
key=${key:-links}

function download() {
    name=$1; link=$2

    [ -f $name ] && return
    referer=$(echo $link | sed -n -e 's|^\(.*://\)\([^/]*\)/.*|\1\2|p')

    wget --header="Referer: $referer" -O "$name.temp" $link
    mv "$name.temp" "$name"
}
export -f download

for jf in $@; do
    n=0
    for link in $(jq -r ".$key[]" $jf); do
        n=$((n+1))
        name=$(basename $link)
        name=$(dirname $jf)/$(printf "%03d_%s" $n $name)
        echo $name $link
     done
done | xargs -n 2 -P 8 bash -c 'download "$@"' _

####
exit 0

for jf in "$@"; do
    n=0
    for link in $(jq -r ".$key[]" $jf); do
        n=$((n+1))
        name=$(basename $link)
        name=$(dirname $jf)/$(printf "%03d_%s" $n $name)
        # wget -cO $name $link
     done
done | xargs -n 2 -P 8 wget -O
