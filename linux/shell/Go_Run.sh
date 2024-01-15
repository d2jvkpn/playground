#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

go_file=$1
out=./target/$(basename $go_file | sed 's/\.go$//')

go build -o "$out" $@

mkdir -p target
if [ "${compile:=''}"  == "true" ]; then
    echo "$out"
else
    "$out"
fi
