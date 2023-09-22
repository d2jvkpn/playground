### Kafka docker
---

#### 
- sites:
  - https://hub.docker.com/r/bitnami/kafka/
  - https://docs.confluent.io/platform/current/tutorials/examples/clients/docs/python.html
  - https://github.com/confluentinc/examples
  - https://github.com/bitnami/containers/tree/main/bitnami/kafka
  - https://pkg.go.dev/github.com/Shopify/sarama?utm_source=godoc#Config
- wrapped kafka clients: https://github.com/d2jvkpn/go-web/tree/dev/pkg/kafka
- pull docker images:
```bash
docker pull bitnami/kafka:3.2
docker pull bitnami/zookeeper:3.8
```
- up
```bash
curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-kafka/master/docker-compose.yml > docker-compose.yml
docker-compose up -d
```
- python3
```bash
pip3 install -r requirements.txt
```
