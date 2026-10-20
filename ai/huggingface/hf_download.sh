#!/usr/bin/env bash
set -eu -o pipefail

model="$1"

hf download "$model" --local-dir "$HOME/Workspace/hf_models/$model"
