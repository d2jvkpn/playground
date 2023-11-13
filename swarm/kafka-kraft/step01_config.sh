#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

kafka_version=${kafka_version:-3.6.0}
template=${template:-kafka-node%02d}
port_zero=${port_zero:-29090}
data_dir=${data_dir:-/app/data}
num_partitions=${num_partitions:-3}

num=$1
# echo "==> Number of kafka node: "
# read -t 5 num || true
# [ -z "$num" ] && num=3

####
num_re='^[1-9]+$'
if ! [[ "$num" =~ $num_re ]] ; then
    echo '!!! Error not a valid number': $num >&2
    exit 1
fi

image=registry.cn-shanghai.aliyuncs.com/d2jvkpn/kafka:$kafka_version
docker pull $image

# cluster_id=$(kafka-storage.sh random-uuid)
cluster_id=$(docker run --rm $image kafka-storage.sh random-uuid)
echo "==> Kafka cluster id: $cluster_id, number of nodes: $num"

mkdir -p data

docker run --rm $image cat /opt/kafka/config/kraft/server.properties > data/server.properties

cat > data/kafka.yaml <<EOF
version: $kafka_version
cluster_id: $cluster_id
data_dir: $data_dir
num_partitions: $num_partitions
EOF

# controller.quorum.voters=1@localhost:9093
# controller.quorum.voters=1@kafka-node1:9093,2@kafka-node2:9093,3@kafka-node3:9093
controller_quorum_voters=$(for i in $(seq 1 $num); do echo $(printf %d@$template:9093 $i $i); done)
controller_quorum_voters=$(echo $controller_quorum_voters | sed 's/ /,/g')

echo "==> controller_quorum_voters: $controller_quorum_voters"

for node_id in $(seq 1 $num); do
    node=$(printf $template $node_id)
    node_id=$node_id

    # advertised.listeners=PLAINTEXT://kafka-node1:9092
    # advertised.listeners=PLAINTEXT://localhost:29092
    advertised_listeners=PLAINTEXT://localhost:$(($port_zero + $node_id))

    mkdir -p data/$node/{configs,data,logs}

    cat data/server.properties | sed \
      -e "/^log.dirs/s#=/.*#=$data_dir#" \
      -e "/^node.id=/s#=.*#=$node_id#" \
      -e "/^advertised.listeners=/s#=.*#=$advertised_listeners#" \
      -e "/^controller.quorum.voters=/s#=.*#=$controller_quorum_voters#" \
      -e "/^num.partitions=/s#=.*#=$num_partitions#" > data/$node/server.properties

cat > data/$node/configs/kafka.yaml <<EOF
$(cat data/kafka.yaml)

node_id: $node_id
advertised_listeners: $advertised_listeners
controller_quorum_voters: $controller_quorum_voters
EOF

    echo "==> node: $node, config: data/$node/configs/{kafka.yaml,server.properties}"
done
