#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


mkdir -p data/qdrant/snapshots data/qdrant/storage

export USER_UID=$(id -u) USER_GID=$(id -g)
envsubst < compose.qdrant.yaml > compose.yaml


exit
docker-compose up -d
