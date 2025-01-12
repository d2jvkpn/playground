#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

node=$1 port=$2

container=${container:-elastic01}
pass_file=configs/$container/elastic.pass
auth="--cacert configs/$container/certs/http_ca.crt -u elastic:$(cat $pass_file)"

#### 1.
[ ! -s $pass_file ] &&
  docker exec $container \
  bash -c "printf 'y' | elasticsearch-reset-password -u elastic" |
  awk '/New value/{print $NF}' |
  dos2unix > $pass_file

token=$(docker exec $container elasticsearch-create-enrollment-token -s node | dos2unix)

if [[ -z "$token" || "$token" == *" "* ]]; then
    echo "Invalid token2: $token2"
    exit 1
fi

#### 2.
mkdir -p data/$node

export ENROLLMENT_TOKEN=$token ES_NODE=$node ES_PORT=$2
envsubst < compose.node.yaml > compose.$node.local

docker-compose -f compose.$node.local up -d
