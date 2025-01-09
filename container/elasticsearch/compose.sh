#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

# https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html

# docker pull docker.elastic.co/elasticsearch/elasticsearch-wolfi:8.17.0

docker pull docker.elastic.co/elasticsearch/elasticsearch:8.17.0
docker network create elastic


# wget https://artifacts.elastic.co/cosign.pub
# cosign verify --key cosign.pub docker.elastic.co/elasticsearch/elasticsearch:8.17.0


docker run --name es01 --net elastic -p 9200:9200 -it -m 1GB docker.elastic.co/elasticsearch/elasticsearch:8.17.0

docker run --name es01 --net elastic -p 9200:9200 -it -m 6GB -e "xpack.ml.use_auto_machine_memory_percent=true" docker.elastic.co/elasticsearch/elasticsearch:8.17.0

docker exec -it es01 /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic

docker exec -it es01 /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana

docker cp es01:/usr/share/elasticsearch/config/certs/http_ca.crt ./

curl --cacert http_ca.crt -u elastic:$ELASTIC_PASSWORD https://localhost:9200


docker exec -it es01 /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s node


docker run -e ENROLLMENT_TOKEN="<token>" --name es02 --net elastic -it -m 1GB docker.elastic.co/elasticsearch/elasticsearch:8.17.0

curl --cacert http_ca.crt -u elastic:$ELASTIC_PASSWORD https://localhost:9200/_cat/nodes


docker pull docker.elastic.co/kibana/kibana:8.17.0
