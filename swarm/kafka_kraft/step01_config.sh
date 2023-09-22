#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

set -x

kafka_version=3.5.0; [ $# -gt 0 ] && kafka_version=$1

echo "Number of kafka node?"
read -t 5 num || true
[ -z "$num" ] && num=3

####
num_re='^[1-9]+$'
if ! [[ "$num" =~ $num_re ]] ; then
    echo "Error not a valid number: $num" >&2
    exit 1
fi

image=registry.cn-shanghai.aliyuncs.com/d2jvkpn/kafka:$kafka_version
# cluster_id=$(kafka-storage.sh random-uuid)
cluster_id=$(docker run --rm $image kafka-storage.sh random-uuid)
echo "==> Kafka cluster id: $cluster_id, number of nodes: $num"

cat > data/kafka.env <<EOF
export KAFKA_CLUSTER_ID=$cluster_id
export KAFKA_NUM_PARTITIONS=3
EOF

for i in $(seq 1 $num); do
    node=kafka-node${i}
    mkdir -p data/$node/{configs,data,logs}
    cp data/kafka.env data/$node/configs
done
