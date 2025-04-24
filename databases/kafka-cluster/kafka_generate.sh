#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


kafka_version=${kafka_version:-4.0.0}
expose_port=${expose_port:-29090}
data_dir=${data_dir:-/opt/data/kafka}
num_partitions=${num_partitions:-3}

# echo "==> Number of kafka node: "
# read -t 5 num || true
# [ -z "$num" ] && num=3
num=$1


####
num_re='^[1-9]+$'
if [[ ! "$num" =~ $num_re ]]; then
    >&2 echo '!!! Error not a valid number': $num
    exit 1
fi

#image=registry.cn-shanghai.aliyuncs.com/d2jvkpn/kafka:$kafka_version
#docker pull $image
image=local/kafka:$kafka_version

#### 1. generate configs of cluster
# cluster_id=$(kafka-storage.sh random-uuid)
cluster_id=$(docker run --rm $image kafka-storage.sh random-uuid)
echo "==> Kafka cluster id: $cluster_id, number_of_nodes: $num, num_partitions: $num_partitions"

mkdir -p data data/kafka-kafdrop

cat > data/kafka.yaml <<EOF
version: $kafka_version
data_dir: $data_dir
num_partitions: $num_partitions
cluster_id: $cluster_id

# node_id: 1
# node_name: kafka-node01
# node_uuid: xxxx
# advertised_listeners: PLAINTEXT://kafka-node01:9092,PLAINTEXT://localhost:29091
# process_roles: broker,controller
# controller_quorum_voters: 1@kafka-node01:9093:JEXY6aqzQY-32P5TStzaFg,2@kafka-node02:9093:MvDxzVmcRsaTz33bUuRU6A,3@kafka-node03:9093:07R5amHmR32VDA6jHkGbTA
EOF


#### 2. generate configs of nodes
for node_id in $(seq 1 $num); do
    node_name=$(printf "kafka-node%02d" $node_id)
    node_uuid=$(docker run --rm $image kafka-storage.sh random-uuid)
    advertised_listeners=PLAINTEXT://localhost:$(($expose_port + $node_id))

    mkdir -p data/$node_name logs/$node_name
cat > data/$node_name/kafka.yaml <<EOF
$(sed '/^#/d' data/kafka.yaml)

node_id: $node_id
node_name: $node_name
node_uuid: $node_uuid
advertised_listeners: $advertised_listeners
process_roles: broker,controller
controller_quorum_voters: $node_id@$node_name:9093:$node_uuid
EOF

    echo "==> node: $node_name, config: data/$node_name/kafka.yaml"
done


controller_quorum_voters=$(
  yq -e '.controller_quorum_voters' data/kafka-node*/kafka.yaml |
    sed ':a; N; $!ba; s/\n---\n/\,/g'
)

echo "==> controller_quorum_voters: $controller_quorum_voters"

sed -i "/controller_quorum_voters:/ s/:.*/: $controller_quorum_voters/" data/kafka-node*/kafka.yaml

#### 2. generate compose.yaml
export TAG=$kafka_version USER_UID=$(id -u) USER_GID=$(id -g)
envsubst < compose.kafka.yaml > compose.yaml

echo "==> compose.yaml created"

exit

docker-compose up -d
docker-compose ps
sleep 5

ls -1 \
   data/kafka-node*/meta.properties \
   data/logs/kafka-node*
