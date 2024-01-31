#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

docker build --no-cache --squash -f Dockerfile \
  -t registry.cn-shanghai.aliyuncs.com/d2jvkpn/kafka:3.3.1 ./
