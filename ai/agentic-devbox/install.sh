#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
cat <<EOF
Install and configure oh-my-opencode by following the instructions here:
https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/refs/heads/master/docs/guide/installation.md
EOF

oh-my-opencode install --no-tui \
  --claude=yes/no/max20 \
  --openai=yes/no \
  --gemini=yes/no \
  --copilot=yes/no \
  --opencode-zen=yes/no \
  --zai-coding-plan=yes/no

opencode auth login

# opencode config
cat ~/.config/opencpde/opencode.json

# models of agents
cat ~/.config/opencpde/oh-my-opencode.json

exit
export CARGO_HOME=/home/appuser/apps/rust/cargo
export RUSTUP_HOME=/home/appuser/apps/rust/rustup

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

exit
ls AGENTS.md
ls docs/PROJECT_CONTEXT.md
ls docs/DECISIONS.md
