#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


# addrs=localhost:29091
# addrs=kafka-node01:9092,kafka-node02:9092,kafka-node03:9092
# addrs=${1:-localhost:9092}

# docker exec -it kafka-node01 bash

addrs=localhost:29091,localhost:29092,localhost:29093

echo "==> kafka-metadata-quorum.sh"
kafka-metadata-quorum.sh --bootstrap-server $addrs describe --status


echo "==> kafka-topics.sh"
kafka-topics.sh --bootstrap-server $addrs --version


topic=test-0001
echo "==> create topic: $topic"
# --partitions 3 --replication-factor 3
kafka-topics.sh --bootstrap-server $addrs --create --topic $topic

kafka-topics.sh --bootstrap-server $addrs --list

kafka-topics.sh --bootstrap-server $addrs --describe --topic $topic

cat > data/temp_msg01.txt <<EOF
this is a string message
with a line break/this is
another message with two
line breaks!
EOF

echo "==> produce messages"
kafka-console-producer.sh --bootstrap-server $addrs --topic $topic < data/temp_msg01.txt

echo "==> consume messages"
kafka-console-consumer.sh --bootstrap-server $addrs \
  --topic $topic --from-beginning --max-messages 4

#kafka-console-consumer.sh --bootstrap-server $addrs \
#  --topic $topic --partition 1 --offset 1 --max-messages 2

echo "==> delete topic: $topic"
kafka-topics.sh --bootstrap-server $addrs --delete --topic $topic

# kafka-dump-log.sh --cluster-metadata-decoder --files tmp/kraft-combined-logs/_cluster_metadata-0/00000000000000023946.log
