#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


function check_value() {
    name=$1; value=$2
    if [[ -z "$value" || "$value" == "null" ]]; then
        >&2 echo "invalid value: $name, $value"
        exit 1
    fi
}

mkdir -p data/rabbitmq-node{01..03}

export USER_UID=$(id -u) USER_GID=$(id -g)

export RABBITMQ_Cookie=$(yq .rabbitmq.cookie configs/rabbitmq.yaml) \
  RABBITMQ_User=$(yq .rabbitmq.user configs/rabbitmq.yaml) \
  RABBITMQ_Password=$(yq .rabbitmq.password configs/rabbitmq.yaml)

check_value rabbitmq.cookie "$RABBITMQ_Cookie"
check_value rabbitmq.user "$RABBITMQ_User"
check_value rabbitmq.password "$RABBITMQ_Password"

envsubst < compose.template.yaml > compose.yaml
