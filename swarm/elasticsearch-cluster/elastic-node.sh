#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

node=$1
port=$2

container=${container:-elastic01}
pass_file=configs/$container/elastic.pass

[ -f data/$node/node.lock ] && { >&2 echo "file exists: data/$node/node.lock"; exit 1; }

#### 1.
[ ! -s $pass_file ] &&
  docker exec -it $container elasticsearch-reset-password --batch -u elastic |
  awk '/New value:/{print $NF}' |
  dos2unix > $pass_file

password=$(cat $pass_file)
[ -z "$password" ] && { >&2 echo "failed to run elasticsearch-reset-password "; exit 1; }

auth="--cacert configs/$container/certs/http_ca.crt -u elastic:$password"

token=$(docker exec $container elasticsearch-create-enrollment-token -s node | dos2unix)

if [[ -z "$token" || "$token" == *" "* ]]; then
    echo "Invalid token: $token"
    exit 1
fi

#### 2.
mkdir -p data/$node

export ENROLLMENT_TOKEN=$token ES_NODE=$node ES_PORT=$2
envsubst < compose.node.yaml > compose.$node.local

docker-compose -f compose.$node.local up -d

#### 3.
# yq eval '.items[] | select(.name == "a01")'
