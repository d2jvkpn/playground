#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

docker exec -it <container_id_or_name> clickhouse-client
