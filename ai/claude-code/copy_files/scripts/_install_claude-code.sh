#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


curl -fsSL https://claude.ai/install.sh | bash
version=$(~/.local/bin/claude --version | awk '{print $1}')

mv ~/.local/share/claude/versions/$version ~/.local/bin/claude

rm -r ~/.local/share/claude
