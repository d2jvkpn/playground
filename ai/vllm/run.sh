#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


pip install -U vllm "vllm[openai]"

python -m vllm.entrypoints.openai.api_server \
  --model meta-llama/Llama-3.1-8B-Instruct \
  --quantization awq \
  --dtype auto \
  --host 0.0.0.0 --port 8000 \
  --gpu-memory-utilization 0.90

exit
####
from openai import OpenAI
client = OpenAI(base_url="http://localhost:8000/v1", api_key="EMPTY")
resp = client.chat.completions.create(
    model="meta-llama/Llama-3.1-8B-Instruct",
    messages=[{"role":"user","content":"用两句话解释什么是数字孪生"}],
    temperature=0.2,
)
print(resp.choices[0].message.content)

####
curl http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer EMPTY" \
  -d '{
    "model":"meta-llama/Llama-3.1-8B-Instruct",
    "messages":[{"role":"user","content":"用两句话解释什么是数字孪生"}],
    "temperature":0.2
  }'

####
from vllm import LLM, SamplingParams

llm = LLM(
    model="meta-llama/Llama-3.1-8B-Instruct",
    dtype="auto",
    tensor_parallel_size=1,      # 多卡则>1
    gpu_memory_utilization=0.9,
)

params = SamplingParams(temperature=0.2, max_tokens=256, top_p=0.9)
prompts = ["简述什么是 LangGraph？", "vLLM 的核心优势是？"]
outs = llm.generate(prompts, params)
for out in outs:
    print(out.outputs[0].text)

####
docker run --gpus all --rm -p 8000:8000 \
  vllm/vllm-openai:latest \
  --model meta-llama/Llama-3.1-8B-Instruct \
  --dtype auto --gpu-memory-utilization 0.9
