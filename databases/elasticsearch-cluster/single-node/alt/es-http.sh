#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

####
mkdir -p configs/es data/es

docker run --rm -u root:root -w /usr/share/elasticsearch \
  -v ${PWD}/configs/es:/tmp/es \
  docker.elastic.co/elasticsearch/elasticsearch:9.0.0 \
  bash -c 'cp -r config/* /tmp/es/ && chown -R elasticsearch:root /tmp/es'

ls configs/es

# -p 9200:9200
docker run -d --name es \
  --network=host \
  -v $PWD/configs/es:/usr/share/elasticsearch/config \
  -v $PWD/data/es:/usr/share/elasticsearchdata \
  -e ES_JAVA_OPTS="-Xms2g -Xmx2g" \
  -e "discovery.type=single-node" \
  -e "xpack.security.enabled=false" \
  -e "xpack.security.http.ssl.enabled=false" \
  docker.elastic.co/elasticsearch/elasticsearch:9.0.0

####
mkdir -p configs/kibana data/kibana

docker run --rm -u root:root -w /usr/share/kibana \
  -v ${PWD}/configs/kibana:/tmp/kibana \
  docker.elastic.co/kibana/kibana:9.0.0 \
  bash -c 'cp config/* /tmp/kibana && chown -R kibana:root /tmp/kibana'

ls configs/kibana

# -p 5600:5601
docker run -d --name kibana \
  --network=host \
  -v $PWD/configs/kibana:/usr/share/kibana/config \
  -v $PWD/data/kibana:/usr/share/kibana/data \
  -e ES_JAVA_OPTS="-Xms1g -Xmx1g" \
  -e "SERVER_NAME=kibana" \
  -e "XPACK_SECURITY_ENABLED=false" \
  -e "ELASTICSEARCH_HOSTS=http://127.0.0.1:9200" \
  docker.elastic.co/kibana/kibana:9.0.0
