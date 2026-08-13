#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


export CODEX_AUTH_JSON_PATH=~/.codex/auth.json \
    CLAUDE_CODE_USE_OPENAI=1 \
    OPENAI_MODEL=codexplan

openclaude
