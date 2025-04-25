#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


#### show error msg without abort
test -f file_not_exists.txt || echo "file not exists"

#### program exit
test -f file_not_exists.txt

####
echo "exit now"
