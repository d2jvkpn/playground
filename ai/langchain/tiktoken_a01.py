#!/usr/bin/env python3

import tiktoken

# 加载编码
enc = tiktoken.get_encoding("cl100k_base")  # GPT-4/GPT-3.5 的编码
# Get the tokenizer encoding for a specific model (e.g., "gpt-4")
# enc = tiktoken.encoding_for_model("gpt-4")
# enc = tiktoken.encoding_for_model("text-embedding-ada-002")

# 本地分词
text = "你好，世界！"
tokens = enc.encode(text)
print(tokens)  # 输出: [15339, 98, 233, 120, 168, 239, 124, 23257, 123, 82]

# 统计 Token 数
print(len(tokens))  # 输出: 10

# Decode tokens back to text
decoded_text = enc.decode(tokens)
print(decoded_text)  # Output: "Hello, world!"
