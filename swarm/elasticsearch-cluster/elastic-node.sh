#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


node=$1; port=$2

container=${container:-elastic01}
pass_file=configs/$container/elastic.pass

[ -f data/$node/node.lock ] && { >&2 echo "file exists: data/$node/node.lock"; exit 1; }

#### 1. Get token
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


#### 2. Compose up
mkdir -p data/$node

export ENROLLMENT_TOKEN=$token ES_NODE=$node ES_PORT=$2

envsubst < compose.node.yaml > compose.$node.local
docker-compose -f compose.$node.local up -d


#### 3. TODO: Checking if the node has already joined
while true; do
    found=$(
      curl -s $auth "https://localhost:9201/_cat/nodes?v=true&format=yaml" |
        yq eval '.[] | select(.name == "'$node'")'
    )

    [ ! -z "$found" ] && break
    >&2 echo "--> Node not joined yet: $node"
    sleep 5
done

echo "<== Done"
