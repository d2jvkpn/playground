#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)

mlx-serve serve \
  --prefix-cache-disk 20GB \
  --prefix-cache-entries 8 \
  --prefix-cache-mem 4GB \
  --metrics \
  --max-concurrent 1 \
  --pld \
  --skip-mem-preflight \
  --kv-quant 8 \
  --ctx-size 256000 \
  --host 0.0.0.0 \
  --port 11234

# --model-dir ~/models/Qwen3.6-35B-A3B-8bit
# --ctx-size 131072
# --ctx-size 262144
# --prefill-chunk 1024

