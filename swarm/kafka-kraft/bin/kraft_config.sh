#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

yaml=$1; output=$2
template=${template:-/opt/kafka/config/kraft/server.properties}

####
num_partitions=$(yq .num_partitions $yaml)
data_dir=$(yq .data_dir $yaml)

node_id=$(yq .node_id $yaml)
advertised_listeners=$(yq .advertised_listeners $yaml)
process_roles=$(yq .process_roles $yaml)
controller_quorum_voters=$(yq .controller_quorum_voters $yaml)


##### TODO: validate variables: $((${#a} * ${#b} * ${#c})) -eq 0
mkdir -p $(dirname $output)

cat $template | sed \
  -e "/^num.partitions=/s#=.*#=$num_partitions#" \
  -e "/^log.dirs/s#=/.*#=$data_dir#" \
  -e "/^node.id=/s#=.*#=$node_id#" \
  -e "/^advertised.listeners=/s#=.*#=$advertised_listeners#" \
  -e "/^process.roles=/s#=.*#=$process_roles#" \
  -e "/^controller.quorum.voters=/s#=.*#=$controller_quorum_voters#" \
  > $output

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
