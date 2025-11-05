#!/usr/bin/env python3
import io

from PIL import Image, ImageOps

#model        max_resolution  max_size
#Qwen3-VL-2B  896×896         1 MB
#Qwen3-VL-4B  1024×1024       2 MB
#Qwen3-VL-7B  1280×1280       4 MB

img = Image.open("data/images/candy.jpeg").convert("RGB")
#img = Image.open(io.BytesIO(contents))
print(f"image size: {img.size}")

img = ImageOps.exif_transpose(img)
print(f"image size: {img.size}")

img.thumbnail((896, 896))
print(f"image size: {img.size}")

img.save("data/images/candy.thumbnail.jpeg", quality=90, optimize=True)
