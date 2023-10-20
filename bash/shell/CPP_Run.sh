#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

cf=$1

mkdir -p target
out=./target/$(basename ${cf%.cpp})

g++ -std=gnu++20 $cf -o $out

$out
