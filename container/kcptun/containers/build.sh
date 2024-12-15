#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0)

docker build --no-cache -f ${_path}/Containerfile -t kcptun:local ./

