#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


if [ $# -eq 0 ]; then
    claude
else
    settings="$HOME/.claude/settings/claude.$1.json"

    if [ ! -f "$settings" ]; then
        echo "!!! Claude settings not found: $settings" >&2
        exit 1
    fi

    shift
    claude \
      --settings "$settings" \
      --tools "Bash,Read,Edit,Write,Glob,Grep,Monitor,Agent,Skill" \
      --disallowedTools "mcp__*"
      "$@"
fi

exit
CLAUDE_CODE_SIMPLE_SYSTEM_PROMPT=1 \
  claude \
  --permission-mode auto
  --bare
