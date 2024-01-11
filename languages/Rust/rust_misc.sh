#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

curl https://sh.rustup.rs -sSf | sh

rustup component add rust-docs

cargo new hello_world
cd hello_world

