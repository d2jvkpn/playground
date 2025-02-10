from transformers import AutoTokenizer, AutoModelForSequenceClassification

# 选择模型名称
model_name = "bert-base-uncased"

# 加载分词器
tokenizer = AutoTokenizer.from_pretrained(model_name)

# 加载模型
model = AutoModelForSequenceClassification.from_pretrained(model_name)

text = "Hello, how are you?"

# 将文本转换为模型输入
inputs = tokenizer(text, return_tensors="pt")

# 前向传播
outputs = model(**inputs)

# 获取预测结果
logits = outputs.logits


import torch

# 假设是分类任务
predictions = torch.argmax(logits, dim=-1)
print(predictions)

# 保存模型和分词器
model.save_pretrained("./my_local_model")
tokenizer.save_pretrained("./my_local_model")

# 加载本地模型和分词器
model = AutoModelForSequenceClassification.from_pretrained("./my_local_model")
tokenizer = AutoTokenizer.from_pretrained("./my_local_model")
