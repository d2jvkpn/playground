#!/usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# export JULIA_PKG_SERVER=https://mirrors.ustc.edu.cn/julia
# julia

mkdir -p ~/.julia/config

cat > ~/.julia/config/startup.jl << EOF
ENV["JULIA_PKG_SERVER"] = "https://mirrors.ustc.edu.cn/julia"
EOF
