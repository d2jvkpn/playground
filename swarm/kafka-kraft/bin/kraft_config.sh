#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

yaml_config=$1
config_output=$2
config_template=${config_template:-/opt/kafka/config/kraft/server.properties}

####
num_partitions=$(awk '/^num_partitions: /{print $2; exit}' $yaml_config)
data_dir=$(awk '/^data_dir: /{print $2; exit}' $yaml_config)

node_id=$(awk '/^node_id: /{print $2; exit}' $yaml_config)
advertised_listeners=$(awk '/^advertised_listeners: /{print $2; exit}' $yaml_config)
process_roles=$(awk '/^process_roles: /{print $2; exit}' $yaml_config)
controller_quorum_voters=$(awk '/^controller_quorum_voters: /{print $2; exit}' $yaml_config)


##### TODO: validate variables: $((${#a} * ${#b} * ${#c})) -eq 0
mkdir -p $(dirname $config_output)

cat $config_template | sed \
  -e "/^num.partitions=/s#=.*#=$num_partitions#" \
  -e "/^log.dirs/s#=/.*#=$data_dir#" \
  -e "/^node.id=/s#=.*#=$node_id#" \
  -e "/^advertised.listeners=/s#=.*#=$advertised_listeners#" \
  -e "/^process.roles=/s#=.*#=$process_roles#" \
  -e "/^controller.quorum.voters=/s#=.*#=$controller_quorum_voters#" > $config_output

exit

cat /app/kafka/kafka.yaml <<EOF
version: 3.7.0
cluster_id: kFTN1eu1TaSvi4aY5pLVGg
data_dir: /app/kafka/data
num_partitions: 3

node_id: 1
# advertised.listeners: PLAINTEXT://kafka-node1:9092
advertised_listeners: PLAINTEXT://localhost:29091
controller_quorum_voters: 1@kafka-node01:9093,2@kafka-node02:9093,3@kafka-node03:9093
EOF
