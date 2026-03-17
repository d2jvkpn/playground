#!/bin/bash
set -eu


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
        bash "$HOME/.local/bin/openclaw_setup_lan.sh"
    fi

    exec "$@"
fi
