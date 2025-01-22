#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

# docker pull rabbitmq:3-management

image=$(yq .services.rabbitmq.image compose.template.yaml)

export USER_UID=$(id -u) USER_GID=$(id -g)

mkdir -p data/rabbitmq configs/rabbitmq

docker run --rm -v $PWD/configs/rabbitmq:/tmp/rabbitmq $image \
  bash -c "cp -r /etc/rabbitmq/* /tmp/rabbitmq && chown -R $USER_UID:$USER_GID /tmp/rabbitmq"

  envsubst < compose.template.yaml > compose.yaml

docker-compose -f compose.yaml up -d

# docker run -d --name rabbitmq --publish=5672:5672 --publish=15672:15672 \
#  rabbitmq:4-management-alpine

# management webpage
# - url: http://localhost:15672
# - username: guest
# - password: guest
