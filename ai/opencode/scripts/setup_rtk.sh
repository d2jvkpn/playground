#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

# https://github.com/rtk-ai/rtk
# https://github.com/rtk-ai/rtk/releases/download/v0.36.0/rtk-x86_64-unknown-linux-musl.tar.gz

curl -fL -o rtk-x86_64-unknown-linux-musl.tar.gz \
  https://github.com/rtk-ai/rtk/releases/latest/download/rtk-x86_64-unknown-linux-musl.tar.gz

tar -xf rtk-x86_64-unknown-linux-musl.tar.gz -C ~/.local/bin/

exit
rtk init --show

rtk init -g                     # Claude Code
rtk init -g --opencode          # OpenCode
rtk init -g --agent cursor      # Cursor
rtk init --agent windsurf       # Windsurf
rtk init --agent cline          # Cline / Roo Code

rtk gain                        # Summary stats

rtk discover                    # Find missed savings opportunities
rtk discover --all --since 7    # All projects, last 7 days

rtk session                     # Show RTK adoption across recent sessions
