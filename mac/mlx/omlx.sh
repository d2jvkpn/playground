#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)


brew tap jundot/omlx https://github.com/jundot/omlx
brew install jundot/omlx/omlx

mkdir -p ~/.omlx/models

ln -s \
  ~/.cache/hf_models/mlx-community/Qwen3.8-27B-8bit/ \
  ~/.cache/hf_models/mlx-community/Qwen3.8-27B-MTP-8bit/ \
  ~/.omlx/models/

omlx serve \
  --model-dir=~/.omlx/models \
  --memory-guard-gb=56 \
  --paged-ssd-cache-dir=~/.omlx/cache \
  --paged-ssd-cache-max-size=20GB \
  --hot-cache-max-size=4GB \
  --max-concurrent-requests=1 \
  --api-key=sk-xxxxxxxx \
  --host=0.0.0.0 \
  --port=11234

tail -f ~/.omlx/logs/server.log

exit

MODEL="$HOME/.omlx/models/Qwen3.8-27B-8bit"

python3 - "$MODEL" <<'PY'
import json, sys
from pathlib import Path

p = Path(sys.argv[1])
index = p / "model.safetensors.index.json"
if index.exists():
    data = json.loads(index.read_text())
    names = list(data.get("weight_map", {}))
    mtp = [n for n in names if n.startswith("mtp.")]
    print(f"MTP tensors: {len(mtp)}")
    print("\n".join(mtp[:20]))
else:
    print("No weight index; inspect safetensors directly.")
PY

mlx_vlm generate \
  --model mlx-community/Qwen3.8-27B-8bit \
  --draft-model mlx-community/Qwen3.8-27B-MTP-8bit \
  --prompt "Write a Python sorting algorithm" \
  --max-tokens 512

http://127.0.0.1:11234/admin

enable VLM MTP with mlx-community/Qwen3.8-27B-MTP-8bit

exit
brew services info omlx
brew services start omlx
brew services restart omlx
