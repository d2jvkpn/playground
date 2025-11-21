#!/usr/bin/env python3
import os

from dotenv import load_dotenv
load_dotenv("configs/local.env")

from haystack import Pipeline, Document
from haystack.document_stores.in_memory import InMemoryDocumentStore
from haystack.components.retrievers.in_memory import InMemoryBM25Retriever
from haystack.components.rankers import TransformersSimilarityRanker
from haystack.components.builders import PromptBuilder
from haystack.components.generators import OpenAIGenerator

# 1. OpenAI Key
#os.environ["OPENAI_API_KEY"] = "YOUR_API_KEY_HERE"

# 2. 示例文档
docs = [
    Document(content="My name is Alice and I live in Paris."),
    Document(content="My name is Bob and I live in Berlin."),
    Document(content="My name is Carol and I live in Shanghai."),
    Document(content="Paris is the capital of France and a popular tourist destination."),
]

# 3. 文档库 + 写入
document_store = InMemoryDocumentStore()
document_store.write_documents(docs)

# 4. 第一阶段：Retriever（粗检索）
retriever = InMemoryBM25Retriever(document_store=document_store, top_k=10)

# 5. 第二阶段：Ranker（精排 / rerank）
# 这里用一个 cross-encoder 模型做 reranker
ranker = TransformersSimilarityRanker(
    model="BAAI/bge-reranker-base",  # 你可以换成别的 HuggingFace 模型
                                     # 也可以不在这里设 top_k，而是在 run() 里传
)

# 6. Prompt 模板
prompt_template = """
Given these documents, answer the question **only** based on the documents.

Documents:
{% for doc in documents %}
- {{ doc.content }}
{% endfor %}

Question: {{ question }}
Answer in English:
"""

prompt_builder = PromptBuilder(
    template=prompt_template,
    required_variables=["question", "documents"],
)

# 7. LLM
# llm = OpenAIGenerator(client=client, model="gpt-4o-mini")
llm = OpenAIGenerator(model="gpt-4o-mini")

# 8. 搭建 Pipeline
rag_pipeline = Pipeline()
rag_pipeline.add_component("retriever", retriever)
#rag_pipeline.add_component("ranker", ranker)
rag_pipeline.add_component("prompt_builder", prompt_builder)
rag_pipeline.add_component("llm", llm)

# 连接数据流：
# retriever.documents → ranker.documents → prompt_builder.documents → llm
#rag_pipeline.connect("retriever.documents", "ranker.documents")
#rag_pipeline.connect("ranker", "prompt_builder.documents")
rag_pipeline.connect("retriever.documents", "prompt_builder.documents")
rag_pipeline.connect("prompt_builder", "llm")

# 9. 运行：问一个问题
question = "Who lives in Paris?"

result = rag_pipeline.run(
    {
        "retriever": { "query": question },          # 粗检索
        "ranker": { "query": question, "top_k": 3 }, # rerank，这里设真正给 LLM 的 top_k
        "prompt_builder": { "question": question },  # prompt 构造需要 question
    }
)

answer = result["llm"]["replies"][0]
print(f"Question: {question}\nAnswer: {answer}")
