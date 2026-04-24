#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


version=$(docker run --rm q.local/hysteria:latest hysteria version | awk '/Version/{print $2}')

docker tag q.local/hysteria:latest q.local/hysteria:$version
echo q.local/hysteria:$version
