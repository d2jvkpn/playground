#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)


bash -euo pipefail script.sh


python3 -B script.py # -I


node \
  --permission \
  --allow-fs-read="$SKILL_DIR" \
  --allow-fs-read="$WORKSPACE" \
  --allow-fs-write="$WORKSPACE" \
  --allow-child-process \
  --allow-net \
  --allow-worker \
  --allow-addons \
  "$SCRIPT"
