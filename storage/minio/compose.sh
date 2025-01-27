#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


mkdir -p ./data/minio-node0{1..4}/data{1,2} logs/nginx

docker-compose -f compose.template.yaml up -d

exit
docker-compose -f compose.template.yaml down
