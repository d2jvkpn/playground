### Kafka Cluster
---


#### ch01. docs
1. docs
- https://kafka.apache.org/
- https://kafka.apache.org/documentation/#gettingStarted
- https://github.com/obsidiandynamics/kafdrop
- https://hub.docker.com/r/apache/kafka
- https://hub.docker.com/r/bitnami/kafka

2. address
kafka listens bother internal(docker network) and external(host), INTERNAL://kafka-node1:9092,EXTERNAL://localhost:29091

listeners=INTERNAL://0.0.0.0:9092,EXTERNAL://0.0.0.0:9093
listener.security.protocol.map=INTERNAL:PLAINTEXT,EXTERNAL:SSL
inter.broker.listener.name=INTERNAL
advertised.listeners=INTERNAL://kafka.internal:9092,EXTERNAL://broker.example.com:9093
