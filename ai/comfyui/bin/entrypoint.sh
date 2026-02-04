#!/bin/bash
set -eu

if [ -s "/opt/init.sh" ]; then
    echo "$(date +%FT%T%:z) ==> bash run: /opt/init.sh"
    bash /opt/init.sh
elif [ ! -z "$INIT_COMMAND" ]; then
    echo "$(date +%FT%T%:z) ==> bash execute: $INIT_COMMAND"
    bash -c "$INIT_COMMAND"
fi

exec "$@"
