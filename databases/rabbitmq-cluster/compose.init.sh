#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


mkdir -p data/rabbitmq-node{01..03}

export RABBITMQ_Cookie=$(yq .rabbitmq.cookie configs/rabbitmq.yaml)
export RABBITMQ_User=$(yq .rabbitmq.user configs/rabbitmq.yaml)
export RABBITMQ_Password=$(yq .rabbitmq.password configs/rabbitmq.yaml)

envsubst < compose.template.yaml > compose.yaml
