#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


git clone -b master https://github.com/go-shiori/shiori shiori.git


docker build --tag shiori:latest \
  --build-arg=ALPINE_VERSION="3" \
  --build-arg=GOLANG_VERSION="1" \
  ./
