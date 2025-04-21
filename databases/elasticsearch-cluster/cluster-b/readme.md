# Title
---
**version**: 0.1.0
**author**: []
**date**: 1970-01-01

#### ch01. Create a cluster
1. docs
- https://www.elastic.co/
- https://hub.docker.com/_/elasticsearch
- https://github.com/infinilabs/analysis-ik

2. start
```bash
make init

make up

make check

make test
```

3. config kibana
```
make kibana
```

4. shutdown
```bash
make shutdown
```

#### ch02.
1. v8
- docker.elastic.co/elasticsearch/elasticsearch:8.18.0
- docker.elastic.co/kibana/kibana:8.18.0

2. v9
- docker.elastic.co/elasticsearch/elasticsearch:9.0.0
- docker.elastic.co/kibana/kibana:9.0.0
