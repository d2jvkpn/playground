#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)


cargo install pdf-inspector --features ocr --bin pdf2md

mkdir -p ~/.local/lib/pdf-inspector
cd ~/.local/lib/pdf-inspector
wget https://github.com/firecrawl/pdfium-rs/releases/download/native-v7988/firecrawl-pdfium-linux-x64.tgz
tar xzf firecrawl-pdfium-linux-x64.tgz

wget https://github.com/microsoft/onnxruntime/releases/download/v1.27.0/onnxruntime-linux-x64-1.27.0.tgz
tar xzf onnxruntime-linux-x64-1.27.0.tgz

export PDFIUM_LIB_PATH="$HOME/.local/lib/pdf-inspector/lib/libpdfium.so"
export ORT_DYLIB_PATH="$HOME/.local/lib/pdf-inspector/onnxruntime-linux-x64-1.27.0/lib/libonnxruntime.so"

# commands: [detect-pdf, pdf2md, pdf2md scan.pdf --ocr auto]
# pdf2md test-01.pdf --ocr auto --raw
