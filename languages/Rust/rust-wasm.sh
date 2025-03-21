#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


# https://cargo-generate.github.io/cargo-generate/installation.html
sudo apt install libssl-dev

cargo install wasm-pack

cargo install cargo-generate --features vendored-openssl


cargo generate --git https://github.com/rustwasm/wasm-pack-template
