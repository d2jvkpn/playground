#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

kafka_version=${kafka_version:-4.0.0}
template=${template:-kafka-node%02d}
port_zero=${port_zero:-29090}
data_dir=${data_dir:-/opt/data/kafka}
num_partitions=${num_partitions:-3}

# echo "==> Number of kafka node: "
# read -t 5 num || true
# [ -z "$num" ] && num=3
num=${1:-3}

####
num_re='^[1-9]+$'
[[ ! "$num" =~ $num_re ]] && { >&2 echo '!!! Error not a valid number': $num; exit 1; }

#image=registry.cn-shanghai.aliyuncs.com/d2jvkpn/kafka:$kafka_version
#docker pull $image
image=local/kafka:$kafka_version

#### 1. generate configs
# cluster_id=$(kafka-storage.sh random-uuid)
cluster_id=$(docker run --rm $image kafka-storage.sh random-uuid)
echo "==> Kafka cluster id: $cluster_id, number of nodes: $num"

mkdir -p data data/kafka-kafdrop

cat > data/kafka.yaml <<EOF
version: $kafka_version
data_dir: $data_dir
num_partitions: $num_partitions
cluster_id: $cluster_id

# node_id: 1
# advertised_listeners: PLAINTEXT://kafka-node1:9092
# advertised_listeners: PLAINTEXT://localhost:29091
# process_roles: broker,controller
EOF
# controller_quorum_voters: 1@kafka-node01:9093:JEXY6aqzQY-32P5TStzaFg,2@kafka-node02:9093:MvDxzVmcRsaTz33bUuRU6A,3@kafka-node03:9093:07R5amHmR32VDA6jHkGbTA

controller_quorum_voters=$(
  for i in $(seq 1 $num); do
      printf "%d@$template:9093:$(docker run --rm $image kafka-storage.sh random-uuid)," $i $i
  done
)

controller_quorum_voters=${controller_quorum_voters%,}

echo "==> controller_quorum_voters: $controller_quorum_voters"

for node_id in $(seq 1 $num); do
    node=$(printf $template $node_id)
    node_id=$node_id
    advertised_listeners=PLAINTEXT://localhost:$(($port_zero + $node_id))

    mkdir -p data/$node logs/$node
cat > data/$node/kafka.yaml <<EOF
$(cat data/kafka.yaml)

node_id: $node_id
advertised_listeners: $advertised_listeners
process_roles: broker,controller
controller_quorum_voters: $controller_quorum_voters
EOF

    echo "==> node: $node, config: data/$node/kafka.yaml"
done

#### 2. generate compose.yaml
export TAG=$kafka_version USER_UID=$(id -u) USER_GID=$(id -g)
envsubst < compose.template.yaml > compose.yaml

echo "==> compose.yaml created"

exit

docker-compose up -d
docker-compose ps
sleep 5

ls -1 \
   data/kafka-node*/meta.properties \
   data/logs/kafka-node*
