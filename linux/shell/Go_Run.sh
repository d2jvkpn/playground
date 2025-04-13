#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(readlink -f `dirname "$0"`)

go_file=$1
mkdir -p target

out=./target/$(basename $go_file | sed 's/\.go$//')
go build -o "$out" $@

cmd="$out"
[ "${compile:=''}"  == "true" ] && cmd="echo $cmd"
"$cmd"
