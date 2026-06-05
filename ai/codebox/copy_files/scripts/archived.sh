#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


#### gemini
echo "==> install gemini-cli"
npm install -g @google/gemini-cli
mkdir -p ~/.local/share/gemini
rm -rf ~/.gemini
ln -s ~/.local/share/gemini ~/.gemini
# gemini oauth


#### deepseek
echo "==> install deepseek-tui"
curl -fL -o ~/.local/bin/deepseek \
  https://github.com/Hmbown/DeepSeek-TUI/releases/latest/download/deepseek-linux-x64

curl -fL -o ~/.local/bin/deepseek-tui \
  https://github.com/Hmbown/DeepSeek-TUI/releases/latest/download/deepseek-tui-linux-x64

chmod a+x ~/.local/bin/deepseek ~/.local/bin/deepseek-tui

mkdir -p ~/.local/share/deepseek
ln -s ~/.local/share/deepseek ~/.deepseek
