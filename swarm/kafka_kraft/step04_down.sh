#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

docker-compose down

echo '!!! Remove files in data?(yes/no)'
read -t 5 ans || true
[ "$ans" != "yes" ] && exit 0

rm -rf data/kafka-node*
