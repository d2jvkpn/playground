import os

from transformers import AutoModel, AutoTokenizer


model_name = os.sys.argv[1] # bert-base-uncased meta/llama-3.2-1b

model = AutoModel.from_pretrained(model_name)
tokenizer = AutoTokenizer.from_pretrained(model_name)

model_dir = os.path.join("data", model_name)
model.save_pretrained(model_dir)
tokenizer.save_pretrained(model_dir)
