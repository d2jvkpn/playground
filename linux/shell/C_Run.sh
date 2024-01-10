#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

mkdir -p target

C_FILE=$1
bin=$(basename $C_FILE | sed 's/\.c$//')

shift
gcc ${C_FILE} -std=c17 -o target/$bin $*

if [ "${compile:=''}"  == "true" ]; then
    ./target/$bin
else
    echo "./target/$bin"
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
