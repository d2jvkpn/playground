#!/usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

declare -A data

data["cat"]="meow"
data["dog"]="woof"

echo "==> data has ${#data[@]} elements"

echo ${data["cat"]}

for key in ${!data[@]}; do
    echo "==> key: $key"
done

for value in ${data[@]}; do
    echo "==> value: $value"
done
