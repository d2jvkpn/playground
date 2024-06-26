#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

docker pull rabbitmq:3-management

mkdir -p data/rabbitmq configs/rabbitmq
envsubst < docker_deploy.yaml > docker-compose.yaml

# docker run -d --name rabbitmq_app --publish=5672:5672 --publish=15672:15672 rabbitmq:3-management
docker-compose -f docker_deploy.yaml up -d

# management webpage
# - url: http://localhost:15672
# - username: guest
# - password: guest
