# Flowise
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```


#### ch01. 
1. docs
- https://github.com/FlowiseAI/Flowise
- https://hub.docker.com/r/flowiseai/flowise

2. run
```
mkdir -p data/faiss

docker run -d --name flowise \
  -u node \
  -p 3000:3000 \
  -v $(pwd)/data/faiss:/home/node/data/faiss \
  flowiseai/flowise:3.0.11
```

3. examples
```
embedding:
  provider: ollama
  addr: http://localhost:11435
  model: bge-m3:567m

vector_store:
  provider: faiss
  base_path: /home/node/data/faiss/doc_name
```
