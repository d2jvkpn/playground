#!/bin/bash
set -eu

if [ -f "/opt/container_init.sh" ]; then
    echo "$(date +%FT%T%:z) ==> bash run: /opt/container_init.sh"
    bash /opt/container_init.sh
elif [ ! -z "$CONTAINER_INIT_COMMAND" ]; then
    echo "$(date +%FT%T%:z) ==> bash execute: $CONTAINER_INIT_COMMAND"
    bash -c "$CONTAINER_INIT_COMMAND"
fi

if [[ $# -eq 0 ]]; then
    exec "/bin/bash"
else
    exec "$@"
fi
