#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)

mlx-serve \
  --model ~/.mlx-serve/models/mlx-community/Qwen3.8-27B-8bit \
  --drafter ~/.mlx-serve/drafters/z-lab/Qwen3.8-27B-DFlash2 \
  --prefix-cache-disk 20GB \
  --prefix-cache-entries 8 \
  --prefix-cache-mem 4GB \
  --metrics \
  --max-concurrent 1 \
  --pld \
  --skip-mem-preflight \
  --kv-quant 8 \
  --ctx-size 256000 \
  --draft-block-size 4 \
  --serve \
  --host 0.0.0.0 \
  --port 11234

exit
brew install huggingface-cli python-gdbm@3.14

hf download z-lab/Qwen3.8-27B-DFlash2 \
  --local-dir ~/.mlx-serve/drafters/z-lab/Qwen3.8-27B-DFlash2
# seabit-ai/Qwen3.8-27B-DFlash2-4bit
# default dir: ~/.cache/huggingface/hub/
