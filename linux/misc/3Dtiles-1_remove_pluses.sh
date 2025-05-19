#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname $0`)


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
