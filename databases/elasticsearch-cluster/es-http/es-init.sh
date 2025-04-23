#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

####
if [ ! -s compose.yaml ]; then
    cp compose.es.yaml compose.yaml
fi

version=$(yq .services.kibana.image compose.yaml | awk -F ":" '{print $2}')

mkdir -p configs/es data/es configs/kibana data/kibana

####
docker run --rm -u root:root -w /usr/share/elasticsearch \
  -v ${PWD}/configs/es:/tmp/es \
  docker.elastic.co/elasticsearch/elasticsearch:$version \
  bash -c 'cp -r config/* /tmp/es/ && chown -R elasticsearch:root /tmp/es'

docker run --rm -u root:root -w /usr/share/kibana \
  -v ${PWD}/configs/kibana:/tmp/kibana \
  docker.elastic.co/kibana/kibana:$version \
  bash -c 'cp config/* /tmp/kibana && chown -R kibana:root /tmp/kibana'
