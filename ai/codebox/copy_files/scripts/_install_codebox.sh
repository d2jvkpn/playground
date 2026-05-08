#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


mkdir -p ~/.local/bin

#### opencode
echo "===> install opencode"
curl -fsSL https://opencode.ai/install | bash
mv ~/.opencode/bin/opencode ~/.local/bin/
rm -r ~/.opencode

#### claude code
echo "===> install claude code"
# CLAUDE_CONFIG_DIR=~/.claude ===> ~/.config/claude
curl -fsSL https://claude.ai/install.sh | bash
version=$(~/.local/bin/claude --version | awk '{print $1}')

mv ~/.local/share/claude/versions/$version ~/.local/bin/claude
rm -rf ~/.claude && \
ln -s ~/.local/share/claude ~/.claude

#### codex
echo "===> install codex"
# CODEX_HOME=~/.codex ===> ~/.local/share/codex
npm install -g @openai/codex

rm -rf ~/.local/share/codex
mkdir -p ~/.local/share/codex
rm -rf ~/.codex
ln -s ~/.local/share/codex ~/.codex

#### gemini
echo "===> install gemini-cli"
npm install -g @google/gemini-cli
mkdir -p ~/.local/share/gemini
rm -rf ~/.gemini
ln -s ~/.local/share/gemini ~/.gemini
# gemini oauth

#### openspec
echo "===> install openspec"
npm install -g @fission-ai/openspec@latest

#### deepseek
echo "===> install deepseek-tui"
curl -fL -o ~/.local/bin/deepseek \
  https://github.com/Hmbown/DeepSeek-TUI/releases/latest/download/deepseek-linux-x64

curl -fL -o ~/.local/bin/deepseek-tui \
  https://github.com/Hmbown/DeepSeek-TUI/releases/latest/download/deepseek-tui-linux-x64

chmod a+x ~/.local/bin/deepseek ~/.local/bin/deepseek-tui

mkdir -p ~/.local/share/deepseek
ln -s ~/.local/share/deepseek ~/.deepseek
