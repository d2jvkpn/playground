#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

cf=$1

mkdir -p target
out=./target/$(basename ${cf%.cpp})

# -std=gnu++20
g++ $cf -g -o $out

$out

exit 0

gdb $out
