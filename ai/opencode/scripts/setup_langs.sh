#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


####
go env -w GOPATH="${HOME}/.local/share/go" GOBIN=${HOME}/apps/bin GOPROXY="https://goproxy.cn,direct"
cat ~/.config/go/env

export GOCACHE=${HOME}/.cache/go-build

# go install golang.org/x/tools/gopls@latest

####
rustup default stable

cat >> ~/apps/apps.env <<'EOF'
#### rust
export CARGO_HOME=$HOME/apps/cargo
export RUSTUP_HOME=$HOME/apps/rustup

export RUSTUP_UPDATE_ROOT=https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup
export RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup
EOF

cat > ~/apps/cargo/config.toml <<EOF
[source.crates-io]
replace-with = "ustc"

[source.ustc]
registry = "sparse+https://mirrors.ustc.edu.cn/crates.io-index/"

[registries.ustc]
index = "sparse+https://mirrors.ustc.edu.cn/crates.io-index/"
EOF

# cargo install tokei
