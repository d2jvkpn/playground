#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


rustup target add x86_64-pc-windows-gnu
# rustup target add x86_64-pc-windows-msvc

sudo apt-get install mingw-w64

#.cargo/config.toml
#[target.x86_64-pc-windows-gnu]
#linker = "x86_64-w64-mingw32-gcc"

cargo build --target x86_64-pc-windows-gnu

exit
cargo install cross
cross build --target x86_64-pc-windows-gnu
