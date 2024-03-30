#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

sey -x

#### tests
# addrs=localhost:29091
# addrs=kafka-node01:9092,kafka-node02:9092,kafka-node03:9092
# addrs=${1:-localhost:9092}

addrs=localhost:29091,localhost:29092,localhost:29093

kafka-metadata-quorum.sh --bootstrap-server $addrs describe --status

topic=test-0001

# docker exec -it kafka-node01 bash

kafka-topics.sh --bootstrap-server $addrs --version

# --partitions 3 --replication-factor 3
kafka-topics.sh --bootstrap-server $addrs --create --topic $topic

kafka-topics.sh --bootstrap-server $addrs --list

kafka-topics.sh --bootstrap-server $addrs --describe --topic $topic

mkdir -p data
cat > data/msg01.txt <<EOF
this is a string message
with a line break/this is
another message with two
line breaks!
EOF

kafka-console-producer.sh --broker-list $addrs --topic $topic < data/msg01.txt

kafka-console-consumer.sh --bootstrap-server $addrs --topic $topic \
  --from-beginning --max-messages 7

# kafka-console-consumer.sh --bootstrap-server $addrs --topic $topic \
#   --partition 0 --offset 0 --max-messages 7

kafka-topics.sh --bootstrap-server $addrs --delete --topic $topic

# kafka-dump-log.sh --cluster-metadata-decoder --files tmp/kraft-combined-logs/_cluster_metadata-0/00000000000000023946.log
