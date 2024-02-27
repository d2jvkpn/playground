#! /usr/bin/env bash
set -eu -o pipefail
# set -x
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

mkdir -p configs/certs data/es{01..03} data/kibana logs/es{01..03}

docker-compose up -d
