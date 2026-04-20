#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


#### claude code
# CLAUDE_CONFIG_DIR=~/.claude ===> ~/.config/claude
curl -fsSL https://claude.ai/install.sh | bash
version=$(~/.local/bin/claude --version | awk '{print $1}')

mv ~/.local/share/claude/versions/$version ~/.local/bin/claude
rm -rf ~/.claude && \
ln -s ~/.local/share/claude ~/.claude

#### codex
# CODEX_HOME=~/.codex ===> ~/.local/share/codex
npm install -g @openai/codex

rm -rf ~/.local/share/codex
mkdir -p ~/.local/share/codex
rm -rf ~/.codex
ln -s ~/.local/share/codex ~/.codex

#### gemini
npm install -g @google/gemini-cli
mkdir -p ~/.local/share/gemini
rm -rf ~/.gemini
ln -s ~/.local/share/gemini ~/.gemini
# gemini oauth

#### openspec
npm install -g @fission-ai/openspec@latest

exit
####
npm install -g @charmland/crush

openspec --version | awk '{print "openspec: "$1}'
codex --version | awk '{print "codex: "$2}'
gemini --version | awk '{print "gemini-cli: "$1}'
claude --version | awk '{print $1}'
