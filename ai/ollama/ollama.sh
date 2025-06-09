#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


####
curl -fsSL https://ollama.com/install.sh | sh


####
exit

curl http://localhost:11434/api/tags

curl http://localhost:11434/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "llama3.2:3b",
    "messages": [
      {"role": "user", "content": "讲一个有关勇气的故事"}
    ]
  }'


exit
ollama pull mxbai-embed-large:335m

ollama pull bge-m3:567m

curl http://localhost:11434/api/embed -d '{
  "model": "bge-m3:567m",
  "encoding_format": "float",
  "input": "Llamas are members of the camelid family"
}'


exit
curl http://localhost:11434/api/embed -d '{
  "model": "bge-m3:567m",
  "input": "Llamas are members of the camelid family"
}'

curl http://localhost:11434/api/generate -d '{
  "model": "llama3.2:3b",
  "prompt": "你好"
}'
