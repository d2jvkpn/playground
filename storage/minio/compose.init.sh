#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


mkdir -p configs ./data/minio-node0{1..3}/data{1,2} logs/nginx

[ ! -s compose.yaml ] && cp compose.template.yaml compose.yaml
[ ! -s configs/nginx.conf ] && cp nginx.conf configs/
