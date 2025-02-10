#!/bin/python3

from transformers import AutoTokenizer, AutoModelForTokenClassification
from transformers import pipeline

model_dir = "data/deepseek-ai/deepseek-coder-1.3b-instruct"
tokenizer = AutoTokenizer.from_pretrained(model_dir)
model = AutoModelForTokenClassification.from_pretrained(model_dir)

nlp = pipeline("ner", model=model, tokenizer=tokenizer)
# example = "My name is Wolfgang and I live in Berlin"
example = "who are you?"

ner_results = nlp(example)
print(ner_results)
