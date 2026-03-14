#!/bin/bash
set -eu

if [[ $# -eq 0 || ( $# -eq 1 && "$1" == "bash" ) ]]; then
    exec /bin/bash
else
    if [ ! -f "$HOME/.openclaw/openclaw.json" ]; then
        bash "$HOME/.local/bin/openclaw_setup_lan.sh"
    fi
fi

exec "$@"
