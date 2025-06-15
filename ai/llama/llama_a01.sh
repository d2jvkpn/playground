#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


####
mkdir -p data/gguf_models
wget -P data/gguf_models https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf

git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
make -j8

./main -m ../data/gguf_models/mistral-7b-instruct-v0.1.Q4_K_M.gguf \
  -p "法国的首都是哪里？" \
  -n 256 \          # 生成256个token
  -t 8 \            # 使用8个线程
  -c 2048 \         # 上下文长度2048
  --temp 0.7 \      # 温度参数
  --repeat_penalty 1.1

./main -m data/gguf_models/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf -p "你好" -n 128

./chat -m data/gguf_models/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf

./main -m data/gguf_models/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf -f input.txt -o output.txt


./server -m data/gguf_models/mistral-7b-instruct-v0.1.Q4_K_M.gguf -c 2048 --port 8000
exit


####
pip install llama-cpp-python
# 如果需要使用 GPU 加速（支持 CUDA）
pip install llama-cpp-python[server]
