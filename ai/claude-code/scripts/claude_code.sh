#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


# https://code.claude.com/docs/en/env-vars

export CLAUDE_CONFIG_DIR=~/.config/claude
# default: ~/.claude.json ~/.claude/{backups,cache,downloads}

curl -fsSL https://claude.ai/install.sh | bash
version=$(~/.local/bin/claude --version | awk '{print $1}')
mv ~/.local/share/claude/versions/$version ~/.local/bin/claude
