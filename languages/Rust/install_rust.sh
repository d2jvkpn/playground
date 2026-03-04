#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


export CARGO_HOME=$HOME/apps/cargo
export RUSTUP_HOME=$HOME/apps/rustup

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
