#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

#### 1.
ENROLLMENT_TOKEN=$(
  docker exec -it elastic01 elasticsearch-create-enrollment-token -s node |
    dos2unix
)

if [[ -z "$ENROLLMENT_TOKEN" || "$ENROLLMENT_TOKEN" == *" "* ]]; then
    echo "Invalid ENROLLMENT_TOKEN: $ENROLLMENT_TOKEN"
    exit 1
fi

#### 2.
export ENROLLMENT_TOKEN=$ENROLLMENT_TOKEN

mkdir -p data/elastic02 data/elastic03

docker-compose -f compose.nodes.yaml up -d

#### 3.
container=${container:-elastic01}
pass_file=configs/$container/elastic.pass
port=${port:-9200}

auth="--cacert configs/$container/certs/http_ca.crt -u elastic:$(cat $pass_file)"

#docker exec <container_id_or_name> sh -c "hostname -I"
#docker run --add-host=host.docker.internal:host-gateway ... # windows or mac
#docker exec <container_id_or_name> sh -c "ip route | awk '/default/ { print $3 }'"
es_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' elastic02)

addr="https://$es_ip:$port"

echo -e "\n\n######## cluster"
curl $auth $addr -f

echo -e "\n\n######## health"
curl $auth "$addr/_cluster/health" -f
