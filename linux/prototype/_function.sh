#!/usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

####
function hello() {
    echo "Hello, world!"
}

hello

####
function add() {
    a=$1
    b=$2
    ans=$((a + b))

    echo $ans
}

ans=$(add 1 2)
echo "==> ans: $ans"
