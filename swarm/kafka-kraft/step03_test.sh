#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

set -x

#### tests
# addrs=localhost:29091
# addrs=kafka-node01:9092,kafka-node02:9092,kafka-node03:9092
# addrs=${1:-localhost:9092}

addrs=localhost:29091,localhost:29092,localhost:29093

topic=test-0001

# docker exec -it kafka-node01 bash

kafka-topics.sh --bootstrap-server $addrs --version

kafka-topics.sh --bootstrap-server $addrs --list

# --partitions 3 --replication-factor 3
kafka-topics.sh --bootstrap-server $addrs --create --topic $topic

kafka-topics.sh --bootstrap-server $addrs --describe --topic $topic

# kafka-console-producer.sh --broker-list $addrs --topic $topic

# sudo apt -y install kafkacat

kafkacat -b $addrs -t $topic -D/ -P <<EOF
this is a string message
with a line break/this is
another message with two
line breaks!
EOF

kafka-console-consumer.sh --bootstrap-server $addrs --topic $topic \
  --from-beginning --max-messages 7

# kafka-console-consumer.sh --bootstrap-server $addrs --topic $topic \
#   --partition 0 --offset 0 --max-messages 7

kafka-topics.sh --bootstrap-server $addrs --delete --topic $topic

####
kafka-metadata-quorum.sh --bootstrap-server  localhost:29091 describe --status

# kafka-dump-log.sh --cluster-metadata-decoder --files tmp/kraft-combined-logs/_cluster_metadata-0/00000000000000023946.log
