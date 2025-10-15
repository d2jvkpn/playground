#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


pip install -U vllm


python -m vllm.entrypoints.openai.api_server \
  --dtype auto \
  --gpu-memory-utilization 0.9 \
  --max-model-len 8192 \
  --model /path/to/your/hf-model \
  --host 0.0.0.0 --port 8000 \
