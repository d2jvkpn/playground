# vLLM
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```


#### ch01. 
1. docs
- https://github.com/vllm-project/llm-compressor
- https://hub.docker.com/r/vllm/vllm-openai/tags

2. chat
```
python3 -m vllm.entrypoints.openai.api_server \
  --dtype=auto \
  --host=0.0.0.0 \
  --port=8000 \
  --gpu-memory-utilization=0.50 \
  --model=Qwen/Qwen2.5-0.5B  \
  --max-model-len=32768

  # --gpu-memory-utilization=0.95
  # --model=Qwen/Qwen3-VL-2B-Instruct
  # --max-model-len=32768  # 262144

  # --gpu-memory-utilization=0.95
  # --model=Qwen/Qwen3-VL-4B-Instruct
  # --max-model-len=16384  # 262144
  # --quantization=bitsandbytes
  # --kv-cache-dtype=fp8   # optional

  # --quantization=awq
```

3. rerank
```
python3 -m vllm.entrypoints.openai.api_server \
  --model=BAAI/bge-reranker-v2-m3 \
  --task=score \
  --host=0.0.0.0 \
  --port=8000
```
