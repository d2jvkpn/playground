#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

#### show error msg without abort
test -f file_not_exists.txt || echo "file not exists"

#### program exit
test -f file_not_exists.txt

####
echo "exit now"
