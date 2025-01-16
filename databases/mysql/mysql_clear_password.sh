#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

docker-compose down

sed -i -e '/mysql_root\.password/d' -e '/mysql\.env/d' docker-compose.yaml

docker-compose up -d
