#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


# https://code.claude.com/docs/en/env-vars

export CLAUDE_CONFIG_DIR=~/.config/claude
# default: ~/.claude.json ~/.claude/{backups,cache,downloads}

curl -fsSL https://claude.ai/install.sh | bash
version=$(claude --version | awk '{print $2}')

rm ~/.local/bin/claude
XDG_DATA_HOME=${XDG_DATA_HOME:-~/.local/share}

mv $XDG_DATA_HOME/claude ~/.local/
ln -s ~/.local/$version ~/.local/bin/claude
