from transformers import T5Tokenizer, T5ForConditionalGeneration


tokenizer = T5Tokenizer.from_pretrained("t5-small", cache_dir="./t5_model_v1")
model = T5ForConditionalGeneration.from_pretrained("t5-small", cache_dir="./t5_model_v1")

input_text = "translate English to German: How old are you?"
input_ids = tokenizer(input_text, return_tensors="pt").input_ids

outputs = model.generate(input_ids)
print(tokenizer.decode(outputs[0]))
