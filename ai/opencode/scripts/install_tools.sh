#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)



apt install -y bash-completion
# ls /usr/share/bash-completion/completions/

# read ms office
pip install python-docx openpyxl python-pptx pandas

# read pdf
pip install pypdf pdfplumber pymupdf

# tools: CODEX_HOME=~/.codex
npm install -g @charmland/crush @fission-ai/openspec@latest

npm install -g @openai/codex @google/gemini-cli
