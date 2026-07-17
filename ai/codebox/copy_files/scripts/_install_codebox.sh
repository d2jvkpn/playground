#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


mkdir -p ~/.local/bin

#### opencode
echo "==> install opencode"
curl -fsSL https://opencode.ai/install | bash
mv ~/.opencode/bin/opencode ~/.local/bin/
rm -r ~/.opencode

#### claude code
echo "==> install claude code"
# CLAUDE_CONFIG_DIR=~/.claude ===> ~/.config/claude
curl -fsSL https://claude.ai/install.sh | bash
version=$(~/.local/bin/claude --version | awk '{print $1}')

mv ~/.local/share/claude/versions/$version ~/.local/bin/claude
rm -rf ~/.claude && \
ln -s ~/.local/share/claude ~/.claude

# claude shell:
#/plugin marketplace add openai/codex-plugin-cc
#/plugin install codex@openai-codex
#/reload-plugins
#/codex:setup

curl -fsSL https://github.com/SaladDay/cc-switch-cli/releases/latest/download/install.sh | bash
#CC_SWITCH_CONFIG_DIR=~/.cc-switch

#### codex
echo "==> install codex"
# CODEX_HOME=~/.codex ===> ~/.local/share/codex
npm install -g @openai/codex

mkdir -p ~/.local/share/codex
rm -rf ~/.codex
ln -s ~/.local/share/codex ~/.codex

#### antigravity
echo "==> install antigravity"
curl -fsSL https://antigravity.google/cli/install.sh | bash
mkdir -p ~/.local/share/gemini
rm -rf ~/.gemini
ln -s ~/.local/share/gemini ~/.gemini

#### openspec
echo "==> install openspec"
npm install -g @fission-ai/openspec@latest

#### codewhale
echo "==> install codewhale"
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
echo "==> install openclaude"
npm install -g @gitlawb/openclaude@latest
# CLAUDE_CONFIG_DIR=~/.openclaude
mkdir -p ~/.local/share/openclaude
rm -rf ~/.openclaude
ln -s ~/.local/share/openclaude ~/.openclaude

#### opendev
echo "==> install opendev"
curl -fL -o opendev-cli-x86_64-unknown-linux-gnu.tar.xz \
  https://github.com/opendev-to/opendev/releases/latest/download/opendev-cli-x86_64-unknown-linux-gnu.tar.xz

tar -xf opendev-cli-x86_64-unknown-linux-gnu.tar.xz
mv opendev-cli-x86_64-unknown-linux-gnu/opendev ~/.local/bin
rm -rf opendev-cli-x86_64-unknown-linux-gnu opendev-cli-x86_64-unknown-linux-gnu.tar.xz
