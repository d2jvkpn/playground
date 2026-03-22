#!/bin/sh
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
    # echo init....
    exec "$@"
fi
