#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)

curl http://localhost:11234/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "mlx-community/Qwen3.6-35B-A3B-8bit",
    "messages": [
      {"role": "user", "content": "Write a Go hello world"}
    ],
    "max_tokens": 256
  }'

curl http://127.0.0.1:11234/v1/responses \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "mlx-community/Qwen3.6-35B-A3B-8bit",
    "input": "Write a Go hello world program.",
    "max_output_tokens": 1024
  }'

curl http://localhost:11234/v1/messages \
  -H 'Content-Type: application/json' \
  -H 'x-api-key: local' \
  -H 'anthropic-version: 2023-06-01' \
  -d '{
    "model": "mlx-community/Qwen3.6-35B-A3B-8bit",
    "max_tokens": 256,
    "messages": [
      {"role": "user", "content": "Write a Go hello world"}
    ]
  }'

python3 - <<'PY' > /tmp/prompt128k.txt
chunk = """
The quick brown fox jumps over the lazy dog.
This is synthetic benchmark text for measuring long-context prefill performance.
Each paragraph contains repeated natural language tokens and should not require reasoning.
"""
print(chunk * 3000)
PY

wc -c /tmp/prompt128k.txt

python3 - <<'PY'
import json
text = open("/tmp/prompt128k.txt").read()
open("/tmp/tokenize.json","w").write(json.dumps({
    "model": "mlx-community/Qwen3.6-35B-A3B-8bit",
    "content": text
}))
PY

curl -s http://127.0.0.1:11234/tokenize \
  -H 'Content-Type: application/json' \
  --data-binary @/tmp/tokenize.json
