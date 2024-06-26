#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

if [ -f data/meta.properties ]; then
    kafka-server-start.sh configs/server.properties
    exit 0
fi

. ./configs/kafka.env
KAFKA_DATA_DIR=${KAFKA_DATA_DIR:-$(readlink -f ./data)}

#### The scrpit exists if any variable is unset
# env variables from ./configs/kafka.env
echo "==> Set KAFKA_CLUSTER_ID"
KAFKA_CLUSTER_ID=$(printenv KAFKA_CLUSTER_ID)

echo "==> Set KAFKA_NUM_PARTITIONS"
KAFKA_NUM_PARTITIONS=$(printenv KAFKA_NUM_PARTITIONS)

# env variables from dokcer-compose.yaml
echo "==> Set KAFKA_NODE_ID"
KAFKA_NODE_ID=$(printenv KAFKA_NODE_ID)

echo "==> Set KAFKA_ADVERTISED_LISTENERS"
KAFKA_ADVERTISED_LISTENERS=$(printenv KAFKA_ADVERTISED_LISTENERS)

echo "==> Set KAFKA_CONTROLLER_QUORUM_VOTERS"
KAFKA_CONTROLLER_QUORUM_VOTERS=$(printenv KAFKA_CONTROLLER_QUORUM_VOTERS)

# node.id=1
# advertised.listeners=PLAINTEXT://localhost:9092
# controller.quorum.voters=1@localhost:9093
cat /opt/kafka/config/kraft/server.properties | sed \
  -e "/^log.dirs/s#=/.*#=$KAFKA_DATA_DIR#" \
  -e "/^node.id=/s#=.*#=$KAFKA_NODE_ID#" \
  -e "/^advertised.listeners=/s#=.*#=$KAFKA_ADVERTISED_LISTENERS#" \
  -e "/^controller.quorum.voters=/s#=.*#=$KAFKA_CONTROLLER_QUORUM_VOTERS#" \
  -e "/^num.partitions=/s#=.*#=$KAFKA_NUM_PARTITIONS#" > configs/server.properties

# env | grep "^KAFKA_" > ./kafka.info
mkdir -p data logs

kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c configs/server.properties --ignore-formatted
kafka-server-start.sh configs/server.properties

# cat /opt/kafka/config/kraft/server.properties |
#   sed '/^log.dirs/s#/.*#/home/d2jvkpn/kafka/data#' configs/server.properties

# KAFKA_CLUSTER_ID="$(kafka-storage.sh random-uuid)" && \
#   kafka-storage.sh format -t $KAFKA_CLUSTER_ID --ignore-formatted -c configs/server.properties

# kafka-server-start.sh configs/server.properties
# kafka-server-start.sh -daemon configs/server.properties
