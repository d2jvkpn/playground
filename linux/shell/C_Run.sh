#! /usr/bin/env bash
set -eu -o pipefail
# set -x
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

c_file=$1
out=./target/$(basename $c_file | sed 's/\.c$//')

mkdir -p target
gcc -std=c17 -o $out $@

if [ "${compile:=''}"  == "true" ]; then
    echo "$out"
else
    "$out"
fi

####
exit

gcc hello.c -o target/hello
./target/hello

gcc user_input.c -o target/user_input
./target/user_input


#### library
man 3 random

#### system call
man 2 getpid
