#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


version=$(docker run --rm local/hysteria:latest hysteria version | awk '/Version/{print $2}')

docker tag local/hysteria:latest local/hysteria:$version
echo local/hysteria:$version
