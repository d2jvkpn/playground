#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# docker exec -it redis redis-cli
# auth password

# not secure
password=$(awk '/^requirepass /{print $2}' configs/redis.conf)
docker exec -it redis redis-cli -a "$password"
