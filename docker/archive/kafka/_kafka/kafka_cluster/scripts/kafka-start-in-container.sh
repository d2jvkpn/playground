#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

zookeepers=$(printenv KAFKA_Zookeepers)
broker_id=$(printenv KAFKA_BrokerId)
host=$(printenv KAFKA_Host)
ex_host=$(printenv KAFKA_ExternalHost)
ex_port=$(printenv KAFKA_ExternalPort)

[ -z "$zookeepers" ] && { >&2 echo "KAFKA_Zookeepers is unset"; exit 1; }
[ -z "$broker_id" ] && { >&2 echo "KAFKA_BrokerId is unset"; exit 1; }
[ -z "$host" ] && { >&2 echo "KAFKA_Host is unset"; exit 1; }
[ -z "$ex_host" ] && { >&2 echo "KAFKA_ExternalHost is unset"; exit 1; }
[ -z "$ex_port" ] && { >&2 echo "KAFKA_ExternalPort is unset"; exit 1; }

cat <<EOF
>>> host: $host
    broker_id: $broker_id
    zookeepers: $zookeepers
    external_host: $ex_host
    external_port: $ex_port

EOF

export KAFKA_HEAP_OPTS="-Xmx4G -Xms1G"

# -daemon
bin/kafka-server-start.sh server.properties \
  --override broker.id=$broker_id           \
  --override zookeeper.connect=$zookeepers        \
  --override inter.broker.listener.name=PLAINTEXT \
  --override listener.security.protocol.map=PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT    \
  --override listeners=PLAINTEXT://0.0.0.0:9092,PLAINTEXT_HOST://0.0.0.0:$ex_port           \
  --override advertised.listeners=PLAINTEXT://$host:9092,PLAINTEXT_HOST://$ex_host:$ex_port \
