#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


if [ $# -eq 0 ]; then
    claude
else
    settings="$HOME/.claude/settings.$1.json"

    if [ ! -f "$settings" ]; then
        echo "!!! Claude settings not found: $settings" >&2
        exit 1
    fi

    shift
    claude --settings "$settings" "$@"
fi

exit
claude --permission-mode auto
