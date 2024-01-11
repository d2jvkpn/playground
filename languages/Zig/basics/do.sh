#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

mkdir -p target

zig build-exe hello.zig

mv hello hello.o target/
./target/hello
