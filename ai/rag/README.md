# RAG
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```


#### ch01. 
1. workflow
```
Query
  ↓
Embedding
  ↓
Vector Database
  ↓
Reranker（Cross-Encoder / LLM）
  ↓
TopN
  ↓
LLM genration
```

2. solution
- Embedding: BGE-large-zh / bge-m3
- Milvus: vector + BM25 hybrid
- Rerank: bge-reranker-large
