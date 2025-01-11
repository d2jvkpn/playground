#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

mkdir -p configs/elastic.conf data/elastic01 data/kibana

docker run --rm -u root:root -w /usr/share/elasticsearch \
  -v ${PWD}/configs/elastic.conf:/elastic.conf \
  docker.elastic.co/elasticsearch/elasticsearch:8.17.0 \
  bash -c "cp -ar config/* /elastic.conf/ && \
    chown -R elasticsearch:root /elastic.conf && \
    if [ -f  elastic.conf/elastic.pass ]; then chmod 600 elastic.conf/elastic.pass; fi"
