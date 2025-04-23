#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


HOST_IP=${HOST_IP:-127.0.0.1}

####
if [ ! -s compose.yaml ]; then
    HOST_IP=$HOST_IP envsubst compose.yaml < compose.es.yaml > compose.yaml
    echo "==> Created compose from compose.es.yaml: compose.yaml"
else
    echo "==> Using existing compose file: compose.yaml"
fi

version=$(yq .services.kibana.image compose.yaml | awk -F ":" '{print $2}')

mkdir -p configs/es configs/kibana data/es data/kibana
# chown -R 10000:0 configs/es configs/kibana

####
docker run --rm -u root:root -w /usr/share/elasticsearch \
  -v ${PWD}/configs/es:/tmp/es \
  docker.elastic.co/elasticsearch/elasticsearch:$version \
  bash -c 'cp -r config/* /tmp/es/ && chown -R elasticsearch:root /tmp/es'

docker run --rm -u root:root -w /usr/share/kibana \
  -v ${PWD}/configs/kibana:/tmp/kibana \
  docker.elastic.co/kibana/kibana:$version \
  bash -c 'cp config/* /tmp/kibana && chown -R kibana:root /tmp/kibana'
