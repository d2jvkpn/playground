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
```
2. run
```bash
pip install -r requirements.txt

./huggingface.py download -m deepseek-ai/deepseek-coder-1.3b-instruct

ls data/deepseek-ai/deepseek-coder-1.3b-instruct

./huggingface.py run -m deepseek-ai/deepseek-coder-1.3b-instruct -c "你好"
```
