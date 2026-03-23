#!/bin/bash
set -eu; _dir=$(readlink -f `dirname "$0"`)


if [[ $# -eq 0 ]]; then
    if command -v bash >/dev/null 2>&1; then
        exec bash
    else
        exec sh
    fi
elif [[ "$1" == "bash" || "$1" == "sh" ]]; then
    exec "$@"
else
    if [ ! -f "$HOME/.openclaw/openclaw.json" ]; then
        bash "${_dir}/openclaw_container.sh"
    fi

    exec "$@"
fi
