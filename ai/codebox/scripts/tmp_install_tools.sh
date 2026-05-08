#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
npx -y oh-my-opencode@latest install
#Installation prompt:
#Install and configure oh-my-opencode by following the instructions here:
#https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/refs/heads/dev/docs/guide/installation.md

exit
npm install -g opencode-ai@latest

pip install --no-cache pyright

npx --yes oh-my-opencode@latest install --no-tui \
 --claude=no --openai=no --gemini=no --copilot=no \
 --opencode-zen=no --zai-coding-plan=no --opencode-go=no

npm install -g  oh-my-opencode@latest
npm install -g oh-my-opencode-linux-x64@latest

exit
apt install -y bash-completion
# ls /usr/share/bash-completion/completions/

# read ms office
pip install python-docx openpyxl python-pptx pandas

# read pdf
pip install pypdf pdfplumber pymupdf

exit
rm -rf ~/.npm ~/.cache

opencode --version | awk '{print "opencode: "$1}'

exit
####
npm install -g @charmland/crush

openspec --version | awk '{print "openspec: "$1}'
codex --version | awk '{print "codex: "$2}'
gemini --version | awk '{print "gemini-cli: "$1}'
claude --version | awk '{print $1}'
