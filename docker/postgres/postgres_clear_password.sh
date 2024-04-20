#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

docker-compose down

sed -i -e '/postgres\.password/d' -e '/POSTGRES_PASSWORD_FILE/d' docker-compose.yaml

docker-compose up -d
