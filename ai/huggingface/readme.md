# Title
---
```meta
version: 0.1.0
author: ["Jane Doe<jane.doe@noreply.local>"]
date: 1970-01-01
```


#### Ch01. 
1. models
```yaml
models:
- https://huggingface.co/deepseek-ai/deepseek-coder-1.3b-instruct
- https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2
```
2. run
```bash
pip install -r requirements.txt

python download.py deepseek-ai/deepseek-coder-1.3b-instruct
python run.py data/deepseek-ai/deepseek-coder-1.3b-instruct Hello, world
```


#### Ch02. 
