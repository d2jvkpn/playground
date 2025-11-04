#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


# pip install -U llmcompressor vllm transformers accelerate torch
# -e HF_HUB_TOKEN=hf_xxx

hf_hub_cache=$(pwd)/data/huggingface
HF_HUB_CACHE=${HF_HUB_CACHE:-$hf_hub_cache}

docker run -d --name vllm \
  --gpus all -p 8000:8000 \
  -v $HF_HUB_CACHE:/root/.cache/huggingface:ro \
  -e HF_HUB_OFFLINE=true \
  vllm/vllm-openai:v0.11.0 \
  --dtype=auto --gpu-memory-utilization 0.90 \
  --model=Qwen/Qwen2.5-0.5B --max-model-len=32768 \
  --host=0.0.0.0 --port=8000
# --quantization awq

exit
max_model_len=$(jq .max_position_embeddings config.json)

curl http://localhost:8000/v1/models

curl http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "Qwen/Qwen2.5-0.5B",
    "temperature": 0.2,
    "max_tokens": 256,
    "temperature": 0.2,
    "messages":[{"role":"user","content":"使用介绍一下 large language models 架构。"}]
  }' | jq -r .choices[0].message.content

exit
Large language models (LLMs) are a class of machine learning models that are designed to generate human-like text. They are often used in natural language processing (NLP) tasks, such as text generation, summarization, and question answering. LLMs are composed of multiple layers of neural networks, each with its own architecture and parameters. The first layer of the network is called the encoder, which takes the input text and produces a fixed-length sequence of token embeddings. The second layer of the network is called the decoder, which takes the token embeddings and produces the output text. The decoder is typically trained using a loss function that measures the difference between the predicted output and the true output. The decoder is trained using a backpropagation algorithm, which updates the parameters of the network based on the gradients of the loss function. The decoder is often trained on large datasets, such as the 100M News dataset, which contains millions of news articles and their corresponding summaries. The decoder is then used to generate new text based on the input text.

exit

from openai import OpenAI

client = OpenAI(base_url="http://localhost:8000/v1", api_key="EMPTY")

resp = client.chat.completions.create(
    model="Qwen/Qwen2.5-0.5B",
    messages=[{"role":"user","content":"使用介绍一下 large language models 架构。"}],
    temperature=0.2,
)

print(resp.choices[0].message.content)
