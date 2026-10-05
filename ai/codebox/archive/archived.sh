#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


## gemini
echo "==> install gemini-cli"
npm install -g @google/gemini-cli
mkdir -p ~/.local/share/gemini
rm -rf ~/.gemini
ln -s ~/.local/share/gemini ~/.gemini
# gemini oauth


## deepseek
echo "==> install deepseek-tui"
curl -fL -o ~/.local/bin/deepseek \
  https://github.com/Hmbown/DeepSeek-TUI/releases/latest/download/deepseek-linux-x64

curl -fL -o ~/.local/bin/deepseek-tui \
  https://github.com/Hmbown/DeepSeek-TUI/releases/latest/download/deepseek-tui-linux-x64

chmod a+x ~/.local/bin/deepseek ~/.local/bin/deepseek-tui

mkdir -p ~/.local/share/deepseek
ln -s ~/.local/share/deepseek ~/.deepseek

## claw
. $HOME/.config/claw/settings.env
# CLAW_CONFIG_HOME=$HOME/.local/share/claw
# ANTHROPIC_AUTH_TOKEN=xxxx
# ANTHROPIC_API_KEY=xxxx
# ANTHROPIC_BASE_URL=https://example.com
# OPENAI_BASE_URL="https://api.openai.com/v1"
# OPENAI_API_KEY="sk-..."

exec claw "$@"

exit
# CLAW_CONFIG_HOME=~/.local/share/claw
# settings.json
