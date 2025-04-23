#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


container=${1:-elastic01}

if [ -s configs/$container/elasticsearch.yml ]; then
    echo '!!! file already exists:' configs/$container/elasticsearch.yml
    exit 0
fi

mkdir -p configs/$container data/$container data/kibana

docker run --rm -u root:root -w /usr/share/elasticsearch \
  -v ${PWD}/configs:/apps/configs \
  docker.elastic.co/elasticsearch/elasticsearch:8.17.0 \
  bash -c "cp -ar config/* /apps/configs/$container/ && \
    chown -R elasticsearch:root /apps/configs/$container && \
    if [ -f  /apps/configs/$container/elastic.pass ]; then \
      chmod 600 /apps/configs/$container/elastic.pass; \
    fi"
