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
- https://www.bilibili.com/video/BV1dWt1zrEPv

2. run
```
mkdir -p data/faiss data/flowise

docker run -d --name flowise \
  -p 3000:3000 \
  -v $(pwd)/data/flowise:/root/.flowise \
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
  base_path: /data/faiss/doc_name
```

4. api
```
<script type="module">
    import Chatbot from "https://cdn.jsdelivr.net/npm/flowise-embed/dist/web.js"
    Chatbot.init({
        chatflowid: "648b4e53-f795-46d1-a9dc-f7a58c7209db",
        apiHost: "http://localhost:3000",
    })
</script>
```

```
curl http://localhost:3000/api/v1/prediction/<ChatflowId> \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "question": "Hey, how are you?",
    "history": [
      { "role": "user", "content": "......" },
      { "role": "assistant", "content": "......" }
    ]
  }'

```
