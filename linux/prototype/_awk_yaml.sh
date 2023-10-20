#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

mkdir -p data

cat > data/sd_pkg.conf << EOF
extensions:
- https://github.com/lllyasviel/ControlNet
- https://github.com/Mikubill/sd-webui-controlnet

repositories:
- https://github.com/salesforce/BLIP.git
- https://github.com/sczhou/CodeFormer.git
- https://github.com/crowsonkb/k-diffusion.git
- https://github.com/Stability-AI/stablediffusion.git
- https://github.com/CompVis/taming-transformers.git
EOF

awk 'BEGIN{RS="\n\n"; FS="\n"; OFS=" "}
  /repositories:/{$1=""; gsub("- ", "", $0); print; exit}' data/sd_pkg.conf
