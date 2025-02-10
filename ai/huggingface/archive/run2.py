#!/bin/python3

from transformers import AutoTokenizer, AutoModel

# 从本地加载模型和分词器
model_dir = "data/deepseek-ai/deepseek-coder-1.3b-instruct"

tokenizer = AutoTokenizer.from_pretrained(model_dir)
model = AutoModel.from_pretrained(model_dir)

text = "Hello, how are you?"
inputs = tokenizer(text, return_tensors="pt")

#outputs = model(**inputs)
outputs = model.generate(**inputs, max_length=50)

generated_text = tokenizer.decode(outputs[0], skip_special_tokens=True)
print(f"Generated text: {generated_text}")
