#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `$dirname "$0"`)


docker-compose down

sed -i -e '/mysql_root\.password/d' -e '/mysql\.env/d' compose.yaml

docker-compose up -d
