#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


version=$(docker run --rm ghcr.io/xtls/xray-core:latest version | awk 'NR==1{print $2; exit}')

docker tag ghcr.io/xtls/xray-core:latest ghcr.io/xtls/xray-core:$version
