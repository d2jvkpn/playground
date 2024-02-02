#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

###
docker-compose -f docker_cluster.yaml up -d
exit

###
# can't access through port binding

###
docker exec zookeeper zkCli.sh ls /brokers/ids
docker exec zookeeper zkCli.sh get /brokers/ids/1

###
addrs=broker-1:9092,broker-2:9092,broker-3:9092

docker exec -it broker-1 kafka-console-producer.sh --broker-list $addrs --topic test
# enter messages
# ctrl+d exit

###
docker exec broker-1 bash -c 'KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper-server:2181 \
  kafka-topics.sh --list --bootstrap-server broker-1:9092'

docker exec broker-1 bash -c 'KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper-server:2181 \
  kafka-topics.sh --list --bootstrap-server broker-2:9092'

docker exec broker-1 bash -c 'KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper-server:2181 \
  kafka-topics.sh --list --bootstrap-server broker-3:9092'

docker exec -it broker-1 kafka-console-consumer.sh --bootstrap-server $addrs \
  --topic test --from-beginning
