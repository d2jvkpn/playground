#!/usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})
# set -x

for t in $(find -type d -name '*\+*'); do
    out=$(echo $t | sed 's/+//g')
    # echo "$d => $out"
    mv $t $out
done

for t in $(find -type f -name '*\+*'); do
    out=$(echo $t | sed 's/+//g')
    # echo "$d => $out"
    mv $t $out
done

for t in $(find -type f -name '*.json'); do
    sed -i 's/+//g' $t
done
