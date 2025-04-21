#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

docker-compose down

echo '!!! Remove files in data?(yes/no)'
read -t 5 ans || true
[[ "$ans" != "yes" && "$ans" != "y" ]] && exit 0

rm -rf data/kafka-node*
