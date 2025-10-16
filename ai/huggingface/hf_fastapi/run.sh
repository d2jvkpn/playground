#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


uv venv ~/apps/home.venv
source ~/apps/home.venv/bin/activate

uv pip install -r requirements.txt

exit
uv init
uv add fastapi uvicorn pydantic transformers torch accelerate bitsandbytes openai
uv sync

exit
MODEL_PATH=Qwen/Qwen2.5-0.5B-Instruct API_KEY=local \
    uvicorn app:app --host=0.0.0.0 --port=8000

exit
MODEL_PATH=Qwen/Qwen3-4B QUANTIZE=4bit API_KEY=local \
    uvicorn app:app --host=0.0.0.0 --port=8000
