#!/usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

####
function add() {
    a=$1
    b=$2

    echo $((a + b))
}

export -f add

seq -s ' ' 1 42 | xargs -P 4 -n 2 -r bash -c 'add "$@"' _

exit

####
cmd_file=$1

# -n 1
cat $cmd_file | xargs -P 4 -L 1 -r bash -c '"$@"' _
