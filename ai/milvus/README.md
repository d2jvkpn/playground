# Title
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```


#### ch01. 
1. docs
- https://github.com/milvus-io/milvus

2. usages
- 
```
from pymilvus import MilvusClient, Function, FunctionType

client = MilvusClient(uri="http://localhost:19530")

model_ranker = Function(
    name="semantic_ranker",
    input_field_names=["document"],   # 必须是 VARCHAR 文本字段
    function_type=FunctionType.RERANK,
    params={
        "reranker": "model",
        "provider": "tei",            # 也可以是别的已支持 provider
        "queries": ["你的查询文本"],
        "endpoint": "http://model-service:8080"
    }
)
```
- 
```
results = milvus.search(query_embedding, top_k=50)
reranked = reranker.rank(query, results)
final = reranked[:5]
```
-
```
from pymilvus.model.reranker import BGERerankFunction

bge_rf = BGERerankFunction(
    model_name="BAAI/bge-reranker-v2-m3",
    device="cpu"   # 或 cuda:0
)
```

3. tech
- Vector search: 
- BM25 / Sparse-BM25: TF, IDF, dense vector
- Fulltext: 

4. meta
```
- created_at: 
- updated_at: 
- expires_at: 
- doc_id: md5_xxxxxxxx
- source: 员工手册.pdf | 人事薪资制度.docx | 2025Q1培训材料.pptx
- version: 2026.3.18
- scope: hr

- creator: [Jane]
- tags: []
```
