#!/bin/bash
set -eu

if [[ $# -eq 0 ]]; then
    exec "/bin/bash"
else
    if [ ! -f "$HOME/.openclaw/openclaw.json" ]; then
        bash "$HOME/.local/bin/openclaw_setup.sh"
    fi

    exec "$@"
fi
