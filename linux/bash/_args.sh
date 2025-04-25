#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


last_param="${@: -1}"
all_but_last="${@:1:$#-1}"

echo "last_param: $last_param"
echo "all_but_last: $all_but_last"
