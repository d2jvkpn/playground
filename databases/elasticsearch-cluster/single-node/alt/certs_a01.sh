#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
cat > instances.yml <<EOF
instances:
- name: es01
  ip:
  - 127.0.0.1
  - 192.168.1.100
  dns:
  - localhost
  - es
<<EOF

elasticsearch-certutil cert --silent \
  --pem --in instances.yml --out /certs/bundle.zip

elasticsearch-certutil http

docker run -d --name elasticsearch \
  -p 9200:9200 -p 9300:9300 \
  -e "discovery.type=single-node" \
  -e "xpack.security.enabled=true" \
  -e "xpack.security.http.ssl.enabled=true" \
  -e "xpack.security.http.ssl.key=/usr/share/elasticsearch/config/certs/es01.key" \
  -e "xpack.security.http.ssl.certificate=/usr/share/elasticsearch/config/certs/es01.crt" \
  -e "xpack.security.http.ssl.certificate_authorities=/usr/share/elasticsearch/config/certs/ca.crt" \
  -v $(pwd)/certs:/usr/share/elasticsearch/config/certs \
  docker.elastic.co/elasticsearch/elasticsearch:8.13.0
