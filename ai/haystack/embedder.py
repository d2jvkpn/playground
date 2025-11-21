#!/usr/bin/env python3
from dotenv import load_dotenv
load_dotenv("configs/local.env")

from haystack.document_stores.in_memory import InMemoryDocumentStore
from haystack import Document
from haystack.components.embedders import (
    OpenAIDocumentEmbedder,
    SentenceTransformersDocumentEmbedder,
)
from haystack.components.retrievers.in_memory import InMemoryEmbeddingRetriever


#### 1. 
document_store = InMemoryDocumentStore()

embedder = SentenceTransformersDocumentEmbedder(
    model="./data/huggingface_models/BAAI/bge-m3",  # n_embed=8194， 或 "moka-ai/m3e-base" 等
)
embedder.warm_up()

#embedder = OpenAIDocumentEmbedder(
#    model="text-embedding-3-small",   # 或其他 embedding 模型
#)

docs = [
    Document(content="Alice lives in Paris."),
    Document(content="Bob lives in Berlin."),
    Document(content="Carol lives in Shanghai."),
]

embedded_docs = embedder.run(docs)["documents"]
document_store.write_documents(embedded_docs)


#### 2. 
retriever = InMemoryEmbeddingRetriever(document_store=document_store)

query = "Who lives in Paris?"
query_embed = embedder.run([Document(content=query)])["documents"][0]
hits = retriever.run(query_embedding=query_embed.embedding, top_k=3)
print(hits)
