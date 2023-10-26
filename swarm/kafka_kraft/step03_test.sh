#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

set -x

#### tests
# addrs=localhost:29091
# addrs=kafka-node1:9092,kafka-node2:9092,kafka-node3:9092
# addrs=${1:-localhost:9092}

addrs=localhost:29091,localhost:29092,localhost:29093

topic=test-0001

# docker exec -it kafka-node1 bash

kafka-topics.sh --bootstrap-server $addrs --version

kafka-topics.sh --bootstrap-server $addrs --list

kafka-topics.sh --bootstrap-server $addrs --create --topic $topic
# kafka-topics.sh --bootstrap-server $addrs --create --topic test --partitions 3 --replication-factor 3

kafka-topics.sh --bootstrap-server $addrs --describe --topic $topic

kafka-console-producer.sh --broker-list $addrs --topic $topic

kafka-console-consumer.sh --bootstrap-server $addrs --topic $topic --from-beginning

kafka-console-consumer.sh --bootstrap-server $addrs --topic $topic --partition 0 --offset 0

kafka-topics.sh --bootstrap-server $addrs --delete --topic $topic
