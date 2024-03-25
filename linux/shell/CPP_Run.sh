#! /usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

cpp_file=$1
out=./target/$(basename ${cpp_file%.cpp})

# -std=gnu++20, -std=c++20
# set -x
mkdir -p target
g++ -g -fmodules-ts -std=gnu++20 -O2 -pipe -o "$out" $@

if [ "${compile:=''}"  == "true" ]; then
    echo "$out"
else
    "$out"
fi

exit 0
gdb "$out"
