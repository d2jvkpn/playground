#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

echo "==> docker-compose down"
docker-compose down

echo '!!! Remove files in data?(yes/no)'
read -t 5 ans || true
[ "$ans" != "yes" ] && exit 0

sudo rm -rf data/{node01,node02,node03}
