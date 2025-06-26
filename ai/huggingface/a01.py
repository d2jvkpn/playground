from transformers import AutoTokenizer, AutoModel

# 假设 Llama-3.2-1B 在 Hugging Face 上的模型名称是 'meta/llama-3.2-1b'
model_name = "meta/llama-3.2-1b"

# 加载分词器
tokenizer = AutoTokenizer.from_pretrained(model_name)

# 加载模型
model = AutoModel.from_pretrained(model_name)

# 保存模型和分词器到本地
model.save_pretrained("./llama-3.2-1b")
tokenizer.save_pretrained("./llama-3.2-1b")
