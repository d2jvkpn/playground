# Elasticsearch Cluster
---
**version**: 0.1.0
**author**: [github.com/d2jvkpn]
**date**: 2025-01-12


#### C01. References
1. links
- https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html
- https://github.com/elastic/elasticsearch/blob/8.17/docs/reference/setup/install/docker/docker-compose.yml
- https://www.elastic.co/guide/en/elasticsearch/reference/current/cat-nodes.html

2. machine learning
Machine learning features such as semantic search with ELSER require a larger container with more 
than 1GB of memory. If you intend to use the machine learning capabilities, then start the container
 with this command:

```bash
docker run --name es01 --net elastic -p 9200:9200 -it -m 6GB \
  -e "xpack.ml.use_auto_machine_memory_percent=true" \
  docker.elastic.co/elasticsearch/elasticsearch:8.17.0
```

#### C02. TODO
1. ?? elastic01 fixed ip


#### C03. Create a cluster
1. start
```bash
make init

make up

make test

make elastic02

make elastic03

make test
```

2. shutdown
```bash
make shutdown
```
