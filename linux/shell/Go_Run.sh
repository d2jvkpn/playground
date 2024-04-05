#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

go_file=$1
mkdir -p target

out=./target/$(basename $go_file | sed 's/\.go$//')
go build -o "$out" $@

cmd="$out"
[ "${compile:=''}"  == "true" ] && cmd="echo $cmd"
"$cmd"
