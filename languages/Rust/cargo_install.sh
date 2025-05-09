#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

curl https://sh.rustup.rs -sSf | sh

rustup target add wasm32-unknown-unknown
# rustup target remove wasm32-unknown-unknown
rustup component add clippy rust-docs

sudo apt install gcc-mingw-w64-x86-64
rustup target add x86_64-pc-windows-gnu
cargo build --target=x86_64-pc-windows-msvc

cargo install bench flamegraph \
  cargo-watch cargo-generate cargo-udeps cargo-profiler \
  cargo-modules cargo-expand

cargo +stable test
cargo +nightly test

rustup toolchain install nightly
rustup override set nightly


rustup component add rust-analyzer rust-src
rust-analyzer --version

rustup component list | grep "(installed)"
