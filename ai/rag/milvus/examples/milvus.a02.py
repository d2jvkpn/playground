#!/usr/bin/env python3
from PIL import Image
from transformers import CLIPProcessor, CLIPModel

model = CLIPModel.from_pretrained("openai/clip-vit-base-patch32")
processor = CLIPProcessor.from_pretrained("openai/clip-vit-base-patch32")

image = Image.open("test.jpg")

inputs = processor(images=image, return_tensors="pt")
emb = model.get_image_features(**inputs)

vector = emb.detach().numpy()


collection.insert([
    { "vector": vector, "path": "test.jpg" },
])
