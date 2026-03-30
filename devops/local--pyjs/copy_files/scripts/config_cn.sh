#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


for t in "$@"; do
    case "$t" in
    npm)
        echo "--> config_cn.sh: npm"
        # npm config set prefix ~/.local/npm
        npm config set registry https://registry.npmmirror.com
        ;;
    pip|pip3)
        echo "--> config_cn.sh: pip3"
        pip3 config set global.index-url 'https://pypi.tuna.tsinghua.edu.cn/simple'
        pip3 config set install.trusted-host 'pypi.tuna.tsinghua.edu.cn'
        ;;
    go)
        echo "--> config_cn.sh: go"
        go env -w GOPROXY=https://goproxy.cn,direct
        ;;
    *)
        echo "--> config_cn.sh: unknown target: $t"
        exit 1
        ;;
    esac
done

exit
if command -v npm &>/dev/null; then
    echo "--> config_cn.sh: npm config"
    #npm config set prefix ~/.local/npm
    npm config set registry https://registry.npmmirror.com
fi

if command -v pip3 &>/dev/null; then
    echo "--> config_cn.sh: pip3 config"
    pip3 config set global.index-url 'https://pypi.tuna.tsinghua.edu.cn/simple'
    pip3 config set install.trusted-host 'pypi.tuna.tsinghua.edu.cn'
fi

if command -v go &>/dev/null; then
    echo "--> config_cn.sh: go config"
    go env -w GOPROXY=https://goproxy.cn,direct
fi
