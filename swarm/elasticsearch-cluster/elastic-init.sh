#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

mkdir -p configs/elastic.config data/elastic01 data/kibana

docker run --rm -u root:root -w /usr/share/elasticsearch \
  -v ${PWD}/configs/elastic.config:/elastic.config \
  docker.elastic.co/elasticsearch/elasticsearch:8.17.0 \
  bash -c "cp -ar config/* /elastic.config/ && \
    chown -R elasticsearch:root /elastic.config && \
    if [ -f  /elastic.config/elastic.pass ]; then \
      chmod 600 /elastic.config/elastic.pass;\
    fi"

cp -ar configs/elastic.config configs/elastic01
