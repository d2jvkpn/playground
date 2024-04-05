#!/bin/bash
set -eu -o pipefail -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

[ -z "$(grep "mongos-1:" docker-compose.yaml)" ] && \
  docker stop mongo-mongos-{1..3} && docker rm mongo-mongos-{1..3}

docker-compose down

echo '!!! Remove all files in data?(yes/no)'
read -t 5 ans || true
[ "$ans" != "yes" ] && exit 0

rm -rf data/shard-{1..3}{a..c} data/configsvr-1{a..c} data/mongos-{1..3}
