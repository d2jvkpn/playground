#!/usr/bin/env python3

####
from llama_cpp import Llama

model_path = "data/gguf_models/mistral-7b-instruct-v0.1.Q4_K_M.gguf"

# 初始化模型
llm = Llama(
    model_path=model_path,  # GGUF 模型文件路径
    n_ctx=2048,      # 上下文长度
    n_threads=8,     # 使用8个CPU线程
    n_gpu_layers=0  # 如果不使用GPU设为0
)

# 生成文本
output = llm(
    "法国的首都是哪里？",  # 提示词
    max_tokens=128,     # 最大生成token数
    temperature=0.7,    # 温度参数
    echo=True,          # 是否返回提示词
)

print(output["choices"][0]["text"])


####
import requests

response = requests.post(
    "http://localhost:8000/completion",
    json={
        "prompt": "法国的首都是哪里？",
        "max_tokens": 128,
        "temperature": 0.7
    }
)

print(response.json()["content"])


####
# cpu
Llama(
    model_path=model_path,
    n_threads=8,  # 使用所有CPU核心
    n_batch=512,  # 批处理大小
    use_mmap=True  # 使用内存映射
)

# gpu
Llama(
    model_path=model_path,
    n_gpu_layers=40  # 使用GPU加速的层数
)

####
# pip install transformers ctransformers
from ctransformers import AutoModelForCausalLM

# 加载模型
llm = AutoModelForCausalLM.from_pretrained(
    model_path,
    model_type="mistral",
    lib="avx2",  # 根据CPU指令集选择：basic/avx/avx2/avx512
)

# 生成文本
print(llm("法国的首都是哪里？"))
print(llm("请介绍 mistral"))
