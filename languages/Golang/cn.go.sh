#!/usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

go env -w GOPROXY="https://goproxy.cn,direct"
