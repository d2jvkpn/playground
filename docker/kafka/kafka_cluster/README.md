# Run kafa cluster by using docker
*Udemy-Apache Kafka Series - Kafka Cluster Setup & Administration 2022*

#### 1. build image
```bash
sysctl vm.swappiness=1
[ ! -f /etc/sysctl.conf.bk ] && cp /etc/sysctl.conf /etc/sysctl.conf.bk
echo -e "\n####\nvm.swappiness=1" >> /etc/sysctl.conf

mkdir -p tmp
wget -O tmp/kafka_2.13-3.3.1.tgz https://downloads.apache.org/kafka/3.3.1/kafka_2.13-3.3.1.tgz
tar -xf tmp/kafka_2.13-3.3.1.tgz -C tmp/

docker build --no-cache --squash -f Dockerfile \
  -t registry.cn-shanghai.aliyuncs.com/d2jvkpn/kafka:3.3.1 ./

docker push registry.cn-shanghai.aliyuncs.com/d2jvkpn/kafka:3.3.1
# docker images -f dangling=true -q | xargs -i docker rmi {}

# clean up
sudo rm -r data/kafka-logs-* data/logs-* data/zoopkeeper-*/version-2
```

### 2. create config and data dir
```bash
mkdir -p configs

cat > configs/zookeeper.properties <<EOF
# the directory where the snapshot is stored.
dataDir=/data/zookeeper
# the port at which the clients will connect
clientPort=2181
# disable the per-ip limit on the number of connections since this is a non-production config
maxClientCnxns=0
# Disable the adminserver by default to avoid port conflicts.
# Set the port to something non-conflicting if choosing to enable this
admin.enableServer=false
# admin.serverPort=8080

####
tickTime=2000
initLimit=10
syncLimit=5

server.1=zookeeper-1:2888:3888
server.2=zookeeper-2:2888:3888
server.3=zookeeper-3:2888:3888

4lw.commands.whitelist=stat, ruok, conf, isro
EOF

for i in $(seq 1 3); do
    d=data/zoopkeeper-${i}
    mkdir -p $d && echo $i > $d/myid
done

cat data/*/myid
```

#### 3 deploy-v1
##### 3.1 up and running
```bash
docker-compose -f deploy-v1.yaml up -d

ls data/*/*

# docker-compose -f deploy-v1.yaml down

for i in $(seq 1 3); do
    echo ">> zookeeper-$i srvr"
    echo srvr | nc localhost 218$i; echo
done

echo conf | nc localhost 2181; echo
echo srvr | nc localhost 2181; echo
echo ruok | nc localhost 2181; echo
# dump, envi, ruok, wchs, wchc, wchp, mntr

./kafka_2.13-3.3.1/bin/zookeeper-shell.sh localhost:2181
create /my-node foo

./kafka_2.13-3.3.1/bin/zookeeper-shell.sh localhost:2182
get /my-node
get -s /my-node
delete /my-node
```

##### 3.2 start kafka
```bash
gateway=$(docker network inspect kafka | jq -r .[0].IPAM.Config[0].Gateway)
host=$(hostname)

for i in $(seq 1 3); do
    id=$i
    container=zookeeper-$i
    port=909$i
    ip=$(docker inspect zookeeper-$i | jq -r .[0].NetworkSettings.Networks.kafka.IPAddress)
    echo ">>> $container $ip $port"

    docker exec $container bin/kafka-server-start.sh -daemon server.properties \
      --override broker.id=$id \
      --override zookeeper.connect=zookeeper-1:2181,zookeeper-2:2181,zookeeper-3:2181/kafka
done

docker exec -it zookeeper-1 bash
# github.com/d2jvkpn/go-web/pkg/kafka
# go test -run TestHandler -o TestHandler.out
# docker cp TestHandler.out  zookeeper-1:/opt/kafka
# ./TestHandler.out -- --addrs zookeeper-1:9092,zookeeper-2:9092,zookeeper-3:9092

# you can only connect to kafka in contianers, not host, even kafka service port is exposed to the host
```

#### 4 deploy-v2
```bash
docker-compose -f deploy-v2.2.yaml up -d
docker-compose -f deploy-v2.2.yaml down
```

#### 5. testing
```bash
docker exec -it kafka-1 bash

bin/kafka-topics.sh --bootstrap-server kafka-1:9092 --create --topic first_topic

bin/kafka-console-producer.sh --broker-list kafka-1:9092 --topic test

bin/kafka-console-consumer.sh --bootstrap-server kafka-1:9092 --topic test --from-beginning

bin/kafka-topics.sh --bootstrap-server kafka-1:9092 --list

base64 /dev/urandom | tr -d '\n' | head -c 10000 | fold -w 100 | sed '$a\' > tmp/file10KB.txt
docker cp tmp/file10KB.txt kafka-1:/opt/kafka

docker exec -it kafka-1 bash

bin/kafka-producer-perf-test.sh --producer.config config/producer.properties --topic test \
  --num-records 10000 --throughput 10 --payload-file file10KB.txt \
  --producer-props acks=1 bootstrap.server=kafka-1:9092,kafka-2:9092,kafka-3:9092 \
  --payload-delimiter "A"

bin/kafka-console-consumer.sh --topic test \
  --bootstrap-server=localhost:29091,localhost:29092,localhost:29093
```

#### 5. settings
- ?? unclean.leader.election.enable=true ==> false if you don't want data loss, https://www.conduktor.io/kafka/kafka-topic-configuration-unclean-leader-election
- auto.create.topics.enable=true ==> set to false in proction
- backgroud.threads=10           ==> increase if you have a good CPU
- delete.topic.enable=false      ==> 
- log.flush.interval.messages    ==> don't set it
- log.retention.hours=168        ==> set in regards to your requirements
- message.max.bytes=10000012     ==> increase if you need more than 1MB
- min.insync.replicas=1          ==> set to 2 if you want to be extra safe
- num.io.threads=8               ==> ++if your network io is a bottleneck
- num.recovery.threads.per.data.dir=1 ==> set to number of disks
- num.replica.fetchers=1  ==> increase if your replicas are lagging
- offsets.retention.minutes=1440    ==> after 24 hours you lose offsets
- zookeeper.seesion.timeout.ms=6000 ==> increase if you timeout often
- broker.rack=null             ==> set your to avaiablity zone in AWS
- default.replication.factor=1 ==> set to 2 or 3 in a kafka cluster
- num.partitions=1             ==> set from 3 to 6 in your cluster
- quota.producer.default=10485760 ==> set quota to 10MBs
- quota.consumer.default=10485760 ==> set quota to 10MBs
