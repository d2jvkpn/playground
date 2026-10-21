#!/usr/bin/env bash
set -eu -o pipefail

models=("$@")
echo "==> Models: ${#models[@]}"

for model in "${models[@]}"; do
    echo "--> model: $model"
    output_dir="$HOME/Workspace/hf_models/$model"
    hf download "$model" --local-dir "$output_dir.temp"
    mv "$output_dir.temp" "$output_dir"
done

date +"<== Exit"
