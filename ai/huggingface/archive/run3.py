#!/bin/python3

from transformers import pipeline
from fastapi import FastAPI

generator = pipeline('text-generation', model='gpt2')

from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def root():
  return {"message": "Welcome to the model API"}

@app.post("/generate/")
async def generate_text(prompt: str):
  outputs = generator(prompt, max_length=50, num_return_sequences=1)
  return {"generated_text": outputs[0]['generated_text']}
