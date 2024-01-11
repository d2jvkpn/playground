#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### cargo config
cat > ~/.cargo/config <<EOF
[source.crates-io]
registry = "https://github.com/rust-lang/crates.io-index"
replace-with = "ustc"

[source.ustc]
registry = "git://mirrors.ustc.edu.cn/crates.io-index"
[source.tuna]
registry = "https://mirrors.tuna.tsinghua.edu.cn/git/crates.io-index.git"

[net]
git-fetch-with-cli = true
EOF

exit

#### rust format, cargo vendor, cargo toolchain
echo 'use_small_heuristics = "Max"' > rustfmt.toml

mkdir -p .cargo

cat > .cargo/config.toml << EOF
[source.crates-io]
replace-with = "vendored-sources"

[source.vendored-sources]
directory = "vendor"
EOF

cat > rust-toolchain.toml <<EOF
[toolchain]
channel = "nightly-2023-01-01"
components = [ "rustfmt" ]
targets = [ "wasm32-unknown-unknown" ]
profile = "minimal"
EOF

exit
