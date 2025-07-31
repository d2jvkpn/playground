####
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


####
from transformers import T5Tokenizer, T5ForConditionalGeneration

tokenizer = T5Tokenizer.from_pretrained("t5-small", cache_dir="./t5_model_v1")
model = T5ForConditionalGeneration.from_pretrained("t5-small", cache_dir="./t5_model_v1")

input_text = "translate English to German: How old are you?"
input_ids = tokenizer(input_text, return_tensors="pt").input_ids

outputs = model.generate(input_ids)
print(tokenizer.decode(outputs[0]))


####
import os

from transformers import AutoModel, AutoTokenizer

model_name = os.sys.argv[1] # bert-base-uncased meta/llama-3.2-1b

model = AutoModel.from_pretrained(model_name)
tokenizer = AutoTokenizer.from_pretrained(model_name)

model_dir = os.path.join("data", model_name)
model.save_pretrained(model_dir)
tokenizer.save_pretrained(model_dir)


####
import os

from transformers import AutoModel, AutoTokenizer


model_name = os.sys.argv[1] # "bert-base-uncased"

model_dir = os.path.join("data", model_name)
model = AutoModel.from_pretrained(model_dir)
tokenizer = AutoTokenizer.from_pretrained(model_dir)

inputs = tokenizer("Hello, world!", return_tensors="pt")
outputs = model(**inputs)

####
from transformers import AutoModelForQuestionAnswering, AutoTokenizer, pipeline

# 指定模型和tokenizer的路径
model_path = '/path/to/local/model'

# 加载tokenizer和模型
tokenizer = AutoTokenizer.from_pretrained(model_path)
model = AutoModelForQuestionAnswering.from_pretrained(model_path)

# 创建一个问答pipeline
qa_pipeline = pipeline("question-answering", model=model, tokenizer=tokenizer)

# 定义上下文和问题
context = """
Transformers库是一个强大的工具，适用于自然语言处理任务。
它提供了多种模型，用于文本分类、生成、翻译、问答等多种任务。
"""
question = "Transformers库适用于哪些任务？"

# 执行问答
result = qa_pipeline(question=question, context=context)

# 打印答案
print(f"Answer: {result['answer']}")
