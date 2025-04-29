#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


IMAGE_Tag="$1"; HTTP_Port="$2"

#### deploy
export IMAGE_Tag="${IMAGE_Tag}" HTTP_Port="${HTTP_Port}"

envsubst < ${_dir}/compose.vue-hello.yaml > compose.yaml

exit 0

docker-compose pull
docker-compose up -d
