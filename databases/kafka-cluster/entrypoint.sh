#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

#### 1. setup
yaml=${yaml:-./data/kafka/kafka.yaml}
conf=./data/kafka/kafka.properties
template=${template:-/opt/kafka/config/kraft/server.properties}

#cluster_id=$(awk '/^cluster_id: /{print $2; exit}' $yaml)
cluster_id=$(yq .cluster_id $yaml)
[ -z "$cluster_id" ] && { >&2 echo "cluster_id is unset in $yaml"; exit 1; }

#### 2. generate
num_partitions=$(yq .num_partitions $yaml)
data_dir=$(yq .data_dir $yaml)

node_id=$(yq .node_id $yaml)
advertised_listeners=$(yq .advertised_listeners $yaml)
process_roles=$(yq .process_roles $yaml)
controller_quorum_voters=$(yq .controller_quorum_voters $yaml)

##### TODO: validate variables: $((${#a} * ${#b} * ${#c})) -eq 0
mkdir -p $(dirname $conf)

cat $template | sed \
  -e "/^num.partitions=/s#=.*#=$num_partitions#" \
  -e "/^log.dirs/s#=/.*#=$data_dir#" \
  -e "/^node.id=/s#=.*#=$node_id#" \
  -e "/^advertised.listeners=/s#=.*#=$advertised_listeners#" \
  -e "/^process.roles=/s#=.*#=$process_roles#" \
  -e "/^controller.quorum.voters=/s#=.*#=$controller_quorum_voters#" \
  > $conf

#### 3. run
kafka-storage.sh format --ignore-formatted -t $cluster_id -c $conf # --add-scram

# -daemon
kafka-server-start.sh $conf $@

exit
cat > /apps/data/kafka/kafka.yaml <<EOF
version: 3.9.0
cluster_id: kFTN1eu1TaSvi4aY5pLVGg
data_dir: /apps/data/kafka
num_partitions: 3

node_id: 1
# advertised.listeners: PLAINTEXT://kafka-node1:9092
advertised_listeners: PLAINTEXT://localhost:29091
controller_quorum_voters: 1@kafka-node01:9093,2@kafka-node02:9093,3@kafka-node03:9093
EOF
