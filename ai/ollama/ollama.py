import requests

####
def ask_ollama(prompt, model="mistral"):
    resp = requests.post("http://localhost:11434/api/generate", json={
        "model": model,
        "prompt": prompt,
        "stream": False
    })
    return resp.json()["response"]


####
response = requests.post(
    "http://localhost:11434/api/generate",
    json={"model": "llama3", "prompt": "你好", "stream": True},
    stream=True
)

for chunk in response.iter_lines():
    if chunk:
        print(chunk.decode("utf-8"))


####
import ollama

# 同步生成
response = ollama.generate(
    model="llama3",
    prompt="用 Python 写一个快速排序",
    options={"temperature": 0.7}
)
print(response["response"])

# 流式生成（推荐）
stream = ollama.generate(
    model="mistral",
    prompt="解释梯度下降算法",
    stream=True
)

for chunk in stream:
    print(chunk["response"], end="", flush=True)

####
import aiohttp
import asyncio

async def query_ollama():
    async with aiohttp.ClientSession() as session:
        async with session.post(
            "http://localhost:11434/api/generate",
            json={"model": "phi3", "prompt": "Python 异步编程的最佳实践"},
            timeout=300
        ) as resp:
            data = await resp.json()
            return data["response"]

# 调用示例
response = asyncio.run(query_ollama())
print(response)

####
client = ollama.Client(host='http://127.0.0.1:11434')

response = client.generate(
    model="mistral:7b",
    prompt="生成一段科幻小说",
    options={
        "temperature": 0.8,       # 创造性 (0-1)
        "num_predict": 512,       # 最大token数
        "top_p": 0.9,             # 核采样阈值
        "repeat_penalty": 1.1     # 防重复惩罚
    }
)

print(response.response)

messages = [
    {"role": "user", "content": "Python 的 GIL 是什么？"},
    {"role": "assistant", "content": "全局解释器锁..."},
    {"role": "user", "content": "它如何影响多线程性能？"}
]

response = client.chat(model="mistral:7b", messages=messages)


print(ollama.list())

# 拉取新模型
ollama.pull(model="llama3:8b-instruct-q4_0")

# 删除模型
ollama.delete(model="mistral:7b")
