#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
npm install -g @tobilu/qmd

export QMD_EMBED_MODEL="hf:Qwen/Qwen3-Embedding-0.6B-GGUF/Qwen3-Embedding-0.6B-Q8_0.gguf"
qmd embed -f

cd /path/to/md_dir

qmd collection add .
qmd update
qmd embed

qmd search "有效加班"
qmd vsearch "什么情况下算有效加班"
qmd query "什么是有效加班"

qmd query "什么是有效加班"
qmd query "员工请假流程"
qmd query "离职工资结算"

exit
ls ~/.cache/qmd

qmd status
qmd collection list

####
huggingface-cli download google/embeddinggemma-300m-GGUF \
  embeddinggemma-300M-Q8_0.gguf \
  --local-dir ~/.cache/qmd/models \
  --local-dir-use-symlinks False

####
huggingface-cli download Qwen/Qwen3-Embedding-0.6B-GGUF \
  Qwen3-Embedding-0.6B-Q8_0.gguf \
  --local-dir ~/.cache/qmd/models \
  --local-dir-use-symlinks False

huggingface-cli download Qwen/qwen3-reranker-0.6b-gguf \
  qwen3-reranker-0.6b-q8_0.gguf \
  --local-dir ~/.cache/qmd/models \
  --local-dir-use-symlinks False
