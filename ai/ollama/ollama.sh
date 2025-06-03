#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


####
curl -fsSL https://ollama.com/install.sh | sh


####
curl http://localhost:11434/api/tags

curl http://localhost:11434/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "llama3.2:3b",
    "messages": [
      {"role": "user", "content": "讲一个有关勇气的故事"}
    ]
  }'
