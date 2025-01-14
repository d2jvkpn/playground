#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


template=$1

if [ -s configs/elastic.yaml ]; then
    echo '!!! file already exists:' configs/elastic.yaml
    exit 1
fi

mkdir -p configs/certs
password=$(tr -dc '0-9a-zA-Z' < /dev/urandom | fold -w 32 | head -n1 || true)
PASSWORD="$password" envsubst < $template > configs/elastic.yaml

yq .password configs/elastic.yaml > configs/certs/elastic.pass
yq e '{"instances": .instances}' configs/elastic.yaml > configs/certs/instances.yaml

cat configs/certs/instances.yaml

for name in $(yq .instances[].name $template); do
    if [ -s configs/$name/elasticsearch.yml ]; then
        echo '!!! file already exists:' configs/$name/elasticsearch.yml
        exit 1
    fi

    mkdir -p data/$name
done

docker run --rm -u root:root -w /usr/share/elasticsearch \
  -v ${PWD}/elastic-setup.sh:/usr/share/elasticsearch/elastic-setup.sh \
  -v ${PWD}/configs/certs:/usr/share/elasticsearch/config/certs \
  docker.elastic.co/elasticsearch/elasticsearch:8.17.0 \
  bash elastic-setup.sh

[ -s configs/compose.env ] || cat > configs/compose.env <<EOF
ELASTIC_PASSWORD_FILE=./config/certs/elastic.pass

cluster.name=es-cluster
bootstrap.memory_lock=true
xpack.ml.use_auto_machine_memory_percent=true
xpack.license.self_generated.type=basic

xpack.security.enabled=true
xpack.security.enrollment.enabled=true
xpack.security.http.ssl.enabled=true
xpack.security.http.ssl.certificate_authorities=certs/ca.crt
xpack.security.transport.ssl.enabled=true
xpack.security.transport.ssl.certificate_authorities=certs/ca.crt
xpack.security.transport.ssl.verification_mode=certificate

xpack.security.http.ssl.key: certs/node/node.key
xpack.security.http.ssl.certificate: certs/node/node.crt
xpack.security.transport.ssl.key: certs/node/node.key
xpack.security.transport.ssl.certificate: certs/node/node.crt
EOF

ls -alh configs/elastic.yaml configs/compose.env configs/certs
