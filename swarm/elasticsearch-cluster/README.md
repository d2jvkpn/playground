# Title
---
**version**: 0.1.0
**author**: []
**date**: 1970-01-01

#### C01. chapter01
1. links
- https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html
- https://github.com/elastic/elasticsearch/blob/8.17/docs/reference/setup/install/docker/docker-compose.yml

2. machine learning
Machine learning features such as semantic search with ELSER require a larger container with more than 1GB of memory. If you intend to use the machine learning capabilities, then start the container with this command:

docker run --name es01 --net elastic -p 9200:9200 -it -m 6GB \
  -e "xpack.ml.use_auto_machine_memory_percent=true" docker.elastic.co/elasticsearch/elasticsearch:8.17.0
