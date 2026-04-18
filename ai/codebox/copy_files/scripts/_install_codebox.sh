#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


# CLAUDE_CONFIG_DIR=~/.claude ===> ~/.config/claude
curl -fsSL https://claude.ai/install.sh | bash
version=$(~/.local/bin/claude --version | awk '{print $1}')

mv ~/.local/share/claude/versions/$version ~/.local/bin/claude

rm -r ~/.local/share/claude

mkdir -p ~/.config/claude
rm -rf ~/.claude && \
ln -s ~/.config/claude ~/.claude

# CODEX_HOME=~/.codex ===> ~/.local/share/codex
npm install -g @openai/codex

mkdir -p ~/.local/share/codex
rm -rf ~/.codex
ln -s ~/.local/share/codex ~/.codex

#
npm install -g @fission-ai/openspec@latest

exit
npm install -g @charmland/crush @google/gemini-cli

openspec --version | awk '{print "openspec: "$1}'
codex --version | awk '{print "codex: "$2}'
gemini --version | awk '{print "gemini-cli: "$1}'
claude --version | awk '{print $1}'
