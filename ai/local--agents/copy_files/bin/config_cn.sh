#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


if command -v npm &>/dev/null; then
    echo "--> debian_cn: npm config"
    #npm config set prefix ~/.local/npm
    npm config set registry https://registry.npmmirror.com
fi

if command -v pip3 &>/dev/null; then
    echo "--> debian_cn: pip3 config"
    pip3 config set global.index-url 'https://pypi.tuna.tsinghua.edu.cn/simple'
    pip3 config set install.trusted-host 'pypi.tuna.tsinghua.edu.cn'
fi

if command -v go &>/dev/null; then
    echo "--> debian_cn: go config"
    go env -w GOPROXY=https://goproxy.cn,direct
fi
