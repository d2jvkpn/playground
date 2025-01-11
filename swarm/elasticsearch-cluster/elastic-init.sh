#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


password=$(tr -dc '0-9a-zA-Z' < /dev/urandom | fold -w 32 | head -n1 || true)

mkdir -p configs/certs data/kibana01 # data/es{01..03}

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
        echo "username: elastic"
        echo "password: $password"
        echo "ca: configs/certs/ca.crt"
        echo "instances:"


        for i in $(seq 1 $num); do
            generate elastic$(printf "%02d" $i)
        done
    } > configs/elastic.yaml
else
    echo "==> Using configs/certs/elastic.yaml"
fi

yq .password configs/elastic.yaml > configs/certs/elastic.pass
yq e '{"instances": .instances}' configs/elastic.yaml > configs/certs/instances.yaml

echo '```yaml'
cat configs/certs/instances.yaml
echo '```'

for name in $(yq .instances[].name configs/elastic.yaml); do
    mkdir -p data/$name
done

docker run --rm \
  -v ${PWD}/elastic-setup.sh:/usr/share/elasticsearch/elastic-setup.sh \
  -v ${PWD}/configs/certs:/usr/share/elasticsearch/config/certs \
  -w /usr/share/elasticsearch \
  -u root:root \
  docker.elastic.co/elasticsearch/elasticsearch:8.17.0 \
  bash elastic-setup.sh

ls -alh configs/certs

[ -s configs/compose.env ] || cat > configs/compose.env <<EOF
ELASTIC_VERSION=8.17.0
ELASTIC_PORT=9200
ELASTIC_PASSWORD_FILE=./config/certs/elastic.pass

cluster.name=elastic-cluster
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
EOF
