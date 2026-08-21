#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


mkdir -p ~/.local/bin
mkdir -p ~/.local/share/agents
ln -s ~/.local/share/agents ~/.agents

#### claude code
echo "==> Installing claude code"
# CLAUDE_CONFIG_DIR=~/.claude ===> ~/.config/claude
curl -fsSL https://claude.ai/install.sh | bash
version=$(~/.local/bin/claude --version | awk '{print $1}')

mv ~/.local/share/claude/versions/$version ~/.local/bin/claude
rm -rf ~/.claude && \
mkdir -p ~/.local/share/claude
ln -s ~/.local/share/claude ~/.claude
touch ~/.claude.json
mv ~/.claude.json ~/.local/share/claude/claude.json
ln -s ~/.local/share/claude/claude.json ~/.claude.json

# claude shell:
#/plugin marketplace add openai/codex-plugin-cc
#/plugin install codex@openai-codex
#/reload-plugins
#/codex:setup

#### opencode
echo "==> Installing opencode"
curl -fsSL https://opencode.ai/install | bash
mv ~/.opencode/bin/opencode ~/.local/bin/
rm -r ~/.opencode

#### codex
echo "==> Installing codex"
# CODEX_HOME=~/.codex ===> ~/.local/share/codex
npm install -g @openai/codex

mkdir -p ~/.local/share/codex
rm -rf ~/.codex
ln -s ~/.local/share/codex ~/.codex

#### antigravity
echo "==> Installing antigravity"
curl -fsSL https://antigravity.google/cli/install.sh | bash
mkdir -p ~/.local/share/gemini
rm -rf ~/.gemini
ln -s ~/.local/share/gemini ~/.gemini

#### codewhale
echo "==> Installing codewhale"
# npm install -g codewhale
curl -fL -o ~/.local/bin/codewhale \
  https://github.com/Hmbown/CodeWhale/releases/latest/download/codewhale-linux-x64

curl -fL -o ~/.local/bin/codewhale-tui \
  https://github.com/Hmbown/CodeWhale/releases/latest/download/codewhale-tui-linux-x64

chmod a+x ~/.local/bin/codewhale ~/.local/bin/codewhale-tui
mkdir -p ~/.local/share/codewhale
rm -rf ~/.codewhale
ln -s ~/.local/share/codewhale ~/.codewhale
# codewhale auth set --provider openrouter --api-key "YOUR_OPENROUTER_API_KEY"
# codewhale --provider openrouter --model deepseek/deepseek-v4-pro
#codewhale auth set --provider openai --api-key "YOUR_OPENAI_COMPATIBLE_API_KEY"
#OPENAI_BASE_URL="https://openai-compatible.example/v4" \
#codewhale --provider openai --model glm-5

#### openclaude
echo "==> Installing openclaude"
npm install -g @gitlawb/openclaude@latest
# CLAUDE_CONFIG_DIR=~/.openclaude
mkdir -p ~/.local/share/openclaude
rm -rf ~/.openclaude
ln -s ~/.local/share/openclaude ~/.openclaude
touch ~/.openclaude.json
mv ~/.openclaude.json ~/.local/share/openclaude/
ln -s ~/.local/share/openclaude/openclaude.json ~/.openclaude.json

#### opendev
#echo "==> Installing opendev"
#curl -fL -o opendev-cli-x86_64-unknown-linux-gnu.tar.xz \
#  https://github.com/opendev-to/opendev/releases/latest/download/opendev-cli-x86_64-unknown-linux-gnu.tar.xz

#tar -xf opendev-cli-x86_64-unknown-linux-gnu.tar.xz
#mv opendev-cli-x86_64-unknown-linux-gnu/opendev ~/.local/bin
#rm -rf opendev-cli-x86_64-unknown-linux-gnu opendev-cli-x86_64-unknown-linux-gnu.tar.xz

#### omp
echo "==> Installing omp"
#curl -fsSL https://omp.sh/install | sh
curl -fL -o ~/.local/bin/omp \
  https://github.com/can1357/oh-my-pi/releases/latest/download/omp-linux-x64
chmod a+x ~/.local/bin/omp
mkdir -p ~/.omp
mv ~/.omp ~/.local/share/omp
ln -s ~/.local/share/omp ~/.omp

#### pi
echo "==> Installing pi"
curl -fsSL https://pi.dev/install.sh | sh
#pi update
# PI_CODING_AGENT_DIR=~/.pi/agent
mkdir -p ~/.local/share/pi
rm -rf ~/.pi
ln -s ~/.local/share/pi ~/.pi

#### goose
echo "==> Installing goose"
curl -fsSL https://github.com/aaif-goose/goose/releases/download/stable/download_cli.sh |
  CONFIGURE=false bash

#### jcode
echo "==> Installing jcode"
curl -fsSL https://jcode.sh/install | bash
rm ~/.local/bin/jcode
mv ~/.jcode/builds/versions/*/jcode* ~/.local/bin/
rm -rf ~/.jcode/builds/
mv ~/.jcode ~/.local/share/jcode
ln -s ~/.local/share/jcode ~/.jcode

####
echo "==> Installing codebox tools"
#CC_SWITCH_CONFIG_DIR=~/.cc-switch
curl -fsSL https://github.com/SaladDay/cc-switch-cli/releases/latest/download/install.sh | bash
mkdir -p ~/.cc-switch
mv ~/.cc-switch ~/.local/share/cc-switch
ln -s ~/.local/share/cc-switch ~/.cc-switch

npm install -g @fission-ai/openspec@latest

npm install -g @mermaid-js/mermaid-cli@11.16.0

npm install -g @firecrawl/anydoc
# npx skills add firecrawl/anydoc
# npx skills add firecrawl/anydoc -g -a codex -a claude-code
# npx skills ls -a codex
# npx skills ls -a claude-code

curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh

curl -sSL https://mqlang.org/install.sh | bash

# https://github.com/1jehuang/mermaid-rs-renderer/releases/download/v0.3.1/mmdr-x86_64-unknown-linux-gnu.tar.gz

rm -rf ~/.cache/* ~/.npm
