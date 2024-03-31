#!/usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

script=$1
out=/tmp/$(basename $script | sed 's/.rs$//')
shift
args=$*

rustfmt $script
rustc -o $out $script

function cleanup {
    echo "Removing $out"
    rm -f $out
}

trap cleanup EXIT

$out $args
