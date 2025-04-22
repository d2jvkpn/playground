#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


# WARN: add one node once at a time
node=$1; port=$2; es_ip=$3

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
    echo '!!! Invalid token: '$token
    exit 1
fi


#### 2. Compose up
mkdir -p configs/$node/certs data/$node
container=$node bash elastic-init.sh
cp -r configs/elastic01/certs/http_ca.crt configs/$node/certs/

export ENROLLMENT_TOKEN=$token ES_NODE=$node ES_PORT=$port ES_IP=$es_ip

envsubst < compose.node.yaml > compose.$node.local
docker-compose -f compose.$node.local up -d


#### 3. Checking if the node has already joined
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
