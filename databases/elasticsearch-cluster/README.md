# Elasticsearch Cluster
---
**version**: 0.1.0
**author**: [github.com/d2jvkpn]
**date**: 2025-01-12


#### ch01. References
1. docs
- https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html
- https://github.com/elastic/elasticsearch/blob/8.17/docs/reference/setup/install/docker/docker-compose.yml
- https://www.elastic.co/guide/en/elasticsearch/reference/current/cat-nodes.html
- https://www.elastic.co/docs/reference/kibana/configuration-reference/general-settings

- https://www.elastic.co/
- https://hub.docker.com/_/elasticsearch
- https://github.com/infinilabs/analysis-ik

2. machine learning
Machine learning features such as semantic search with ELSER require a larger container with more 
than 1GB of memory. If you intend to use the machine learning capabilities, then start the container
 with this command:

```bash
docker run --name es01 --net elastic -p 9200:9200 -it -m 6GB \
  -e "xpack.ml.use_auto_machine_memory_percent=true" \
  docker.elastic.co/elasticsearch/elasticsearch:8.17.0
```

3. sysctl
```
sudo sysctl -a | grep vm.max_map_count

# temporary
sudo sysctl -w vm.max_map_count=262144

# permanently
sudo cp /etc/sysctl.conf /etc/sysctl.conf.bk

echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
sudo sysctl --system
```

4. v8
- docker.elastic.co/elasticsearch/elasticsearch:8.18.0
- docker.elastic.co/kibana/kibana:8.18.0

5. v9
- docker.elastic.co/elasticsearch/elasticsearch:9.0.0
- docker.elastic.co/kibana/kibana:9.0.0


#### ch02. Node configurations
1.  node roles
```yaml
node.master: true
node.data: true
```

2. discovery
```yaml
discovery.seed_hosts: ["elastic01", "elastic02", "elastic02"]
cluster.initial_master_nodes: ["elastic01", "elastic02", "elastic02"]
```

#### ch03. certs
1. 
```bash
elasticsearch-certutil ca --pass "" --out http_ca.crt

elasticsearch-certutil cert \
  --ca http_ca.crt --ca-pass "" \
  --dns localhost,example.com \
  --ip 127.0.0.1,192.168.1.11 \
  --pass "" --out http.p12


ls config/elasticsearch.keystore
elasticsearch-keystore list
```

2. 
```
exit
xpack.security.enabled: true
xpack.security.transport.ssl.enabled: true
xpack.security.transport.ssl.verification_mode: full
xpack.security.transport.ssl.keystore.path: /path/to/your/keystore.p12
xpack.security.transport.ssl.keystore.password: your_password
xpack.security.transport.ssl.truststore.path: /path/to/your/keystore.p12
xpack.security.transport.ssl.truststore.password: your_password

xpack.security.http.ssl.enabled: true
xpack.security.http.ssl.keystore.path: /path/to/your/keystore.p12
xpack.security.http.ssl.keystore.password: your_password
xpack.security.http.ssl.truststore.path: /path/to/your/keystore.p12
xpack.security.http.ssl.truststore.password: your_password

exit
xpack.security.transport.ssl.enabled: true
xpack.security.transport.ssl.verification_mode: certificate
xpack.security.transport.ssl.key: /etc/elasticsearch/certs/your-key.key
xpack.security.transport.ssl.certificate: /etc/elasticsearch/certs/your-cert.crt
xpack.security.transport.ssl.certificate_authorities: ["/etc/elasticsearch/certs/ca-cert.crt"]

xpack.security.http.ssl.enabled: true
xpack.security.http.ssl.key: /etc/elasticsearch/certs/your-key.key
xpack.security.http.ssl.certificate: /etc/elasticsearch/certs/your-cert.crt
xpack.security.http.ssl.certificate_authorities: ["/etc/elasticsearch/certs/ca-cert.crt"]
```

3. TODO: p12
```
elasticsearch-certutil ca --silent --pass "" --pem --out elastic-stack-ca.p12


cat > instances.yaml <<EOF
instances:
- name: node1
  ip:
  - 127.0.0.1
  - 192.168.0.11
  dns:
  - localhost
  - nodde02.es
- name: node2
  ip:
  - 127.0.0.1
  - 192.168.0.12
  dns:
  - localhost
  - nodde02.es
EOF

elasticsearch-certutil cert --ca elastic-stack-ca.p12 --pem --in instances.yaml --out certs.zip
```

4. ca
```
elasticsearch-certutil ca --silent --pem -out config/certs/ca.zip

unzip -j config/certs/ca.zip "ca/*" -d config/certs/
ls config/certs/ca.crt config/certs/ca.key

cat > instances.yaml <<EOF
instances:
- name: node1
  ip:
  - 127.0.0.1
  - 192.168.0.11
  dns:
  - localhost
  - nodde02.es
- name: node2
  ip:
  - 127.0.0.1
  - 192.168.0.12
  dns:
  - localhost
  - nodde02.es
EOF

elasticsearch-certutil cert --silent --pem \
  --ca-cert config/certs/ca.crt --ca-key config/certs/ca.key \
  --in instances.yaml \
  -out config/certs/certs.zip

unzip -j config/certs/certs.zip "*/*" -d config/certs

ls config/certs/node01.key config/certs/node01.crt config/certs/node02.key config/certs/node02.crt

cat <<EOF
environment:
- node.name=es01
- cluster.name=${CLUSTER_NAME}
- cluster.initial_master_nodes=es01,es02,es03
- discovery.seed_hosts=es02,es03
- ELASTIC_PASSWORD=${ELASTIC_PASSWORD}
- bootstrap.memory_lock=true
- xpack.security.enabled=true
- xpack.security.http.ssl.enabled=true
- xpack.security.http.ssl.key=certs/es01.key
- xpack.security.http.ssl.certificate=certs/es01.crt
- xpack.security.http.ssl.certificate_authorities=certs/ca.crt
- xpack.security.transport.ssl.enabled=true
- xpack.security.transport.ssl.key=certs/es01.key
- xpack.security.transport.ssl.certificate=certs/es01.crt
- xpack.security.transport.ssl.certificate_authorities=certs/ca.crt
- xpack.security.transport.ssl.verification_mode=certificate
- xpack.license.self_generated.type=${LICENSE}
- xpack.ml.use_auto_machine_memory_percent=true
EOF
```

#### ch04. Chinese
1. 
- analysis-ik
- analysis-icu

2. 
- Analyzer
- Tokenizer
- Token Filters
- Field Mappings
