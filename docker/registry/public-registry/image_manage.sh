#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)/
_path=$(dirname $0)/

#### server machine
docker tag xxx.yyy/hello:latest localhost:${PORT}/hello:latest

docker push localhost:${PORT}/hello:latest

#### localhost
docker pull ${DOMAIN}/hello:latest
