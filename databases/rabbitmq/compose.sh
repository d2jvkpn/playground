#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

# docker pull rabbitmq:3-management

image=$(yq .services.rabbitmq.image compose.template.yaml)

mkdir -p data/rabbitmq configs/rabbitmq

if [ ! -s configs/rabbitmq.pass ]; then
    password=$(tr -dc '0-9a-zA-Z' < /dev/urandom | fold -w 24 | head -n1 || true)
    echo $password > configs/rabbitmq.pass
fi
password=$(cat configs/rabbitmq.pass)

export USER_UID=$(id -u) USER_GID=$(id -g) PASSWORD=$password

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
