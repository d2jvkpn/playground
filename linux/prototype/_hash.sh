#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0)


declare -A map=(
  ["hello"]="world"
  ["answer"]="42"
  ["alice"]="bob"
)

echo ${map["hello"]}, ${map["answer"]}, ${map["alice"]}

unset map["alice"]

echo "map:"
for key in "${!map[@]}"; do
    echo "- { key: $key, value: ${map[$key]} }"
done

map["ok"]="yes"

for key in "${!map[@]}"; do
    echo "- { key: $key, value: ${map[$key]} }"
done
