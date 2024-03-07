#! /usr/bin/env bash
set -eu -o pipefail
# set -x
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

script=$1
# out=/tmp/$(basename $script | sed 's/.rs$//')
out=target/$(basename $script | sed 's/.rs$//')
shift
args=$*

mkdir -p target
rustfmt $script
rustc -o $out $script
# build release with option -C opt-level=3

$out $args

exit

function cleanup {
    # echo "Removing $out"
    rm -f $out
}

trap cleanup EXIT

$out $args
