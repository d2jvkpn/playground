#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

#cat > configs/elastic.yaml <<EOF
#instances:
#- name: es01
#  dns:
#  - localhost
#  - es01
#  ip:
#  - 127.0.0.1
#- name: es02
#  dns:
#  - localhost
#  - es02
#  ip:
#  - 127.0.0.1
#- name: es03
#  dns:
#  - localhost
#  - es03
#  ip:
#  - 127.0.0.1
#EOF

mkdir -p configs/certs # data/es{01..03}

function generate() {
    name=$1
    echo "- name: $name"
    echo "  dns:"
    echo "  - localhost"
    echo "  - $name"
    echo "  ip:"
    echo "  - 127.0.0.1"
}

if [ $# -gt 0 ]; then
    num=$1
    echo "==> Generating configs/elastic.yaml"

    {
        echo "instances:"
        for i in $(seq 1 $num); do generate es$(printf "%02d" $i); done
    } > configs/elastic.yaml
else
    echo "==> Using configs/certs/elastic.yaml"
fi

echo '```yaml'
cat configs/elastic.yaml
echo '```'

for name in $(yq .instances[].name configs/elastic.yaml); do
    mkdir -p data/$name
done


docker run --rm \
  -v ${PWD}/es-setup.sh:/usr/share/elasticsearch/es-setup.sh \
  -v ${PWD}/configs/elastic.yaml:/usr/share/elasticsearch/elastic.yaml \
  -v ${PWD}/configs/certs:/usr/share/elasticsearch/config/certs \
  -v ${PWD}/data:/usr/share/elasticsearch/data \
  -w /usr/share/elasticsearch \
  -u root:root \
  docker.elastic.co/elasticsearch/elasticsearch:8.17.0 \
  bash es-setup.sh

ls -alh configs/certs

[ -s configs/compose.env ] || cat > configs/compose.env <<EOF
ELASTIC_VERSION=8.17.0
ELASTIC_PORT=9200
ELASTIC_PASSWORD=foobar

cluster.name=elastic-cluster
bootstrap.memory_lock=true
xpack.security.enabled=true
xpack.security.enrollment.enabled=true
xpack.security.http.ssl.enabled=true
xpack.security.http.ssl.certificate_authorities=certs/ca/ca.crt
xpack.security.transport.ssl.enabled=true
xpack.security.transport.ssl.certificate_authorities=certs/ca/ca.crt
xpack.security.transport.ssl.verification_mode=certificate
xpack.ml.use_auto_machine_memory_percent=true
xpack.license.self_generated.type=basic
EOF
