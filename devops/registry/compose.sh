#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


http_port=${1:-5000}

mkdir -p data/registry
export HTTP_Port=$http_port

envsubst < ${_dir}/compose.registry.yaml > compose.yaml

exit
docker-compose pull
docker-compose up -d
