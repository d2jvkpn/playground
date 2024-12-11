#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

last_param="${@: -1}"
all_but_last="${@:1:$#-1}"

echo "last_param: $last_param"
echo "all_but_last: $all_but_last"
