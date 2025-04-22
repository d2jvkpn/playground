#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


ls compose.yaml > /dev/null

docker-compose up -d

sleep 5

docker exec -it rabbitmq-node02 bash -c '
rabbitmqctl stop_app &&
rabbitmqctl join_cluster rabbit@rabbitmq-node01 &&
rabbitmqctl start_app
'

docker exec -it rabbitmq-node03 bash -c '
rabbitmqctl stop_app &&
rabbitmqctl join_cluster rabbit@rabbitmq-node01 &&
rabbitmqctl start_app
'
