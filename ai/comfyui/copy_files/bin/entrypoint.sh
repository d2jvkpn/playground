#!/bin/bash
set -eu


#if [ -f "/opt/container_init.sh" ]; then
#    echo "$(date +%FT%T%:z) ==> bash /opt/container_init.sh"
#    bash /opt/container_init.sh
#fi

if [ ! -z "$CONTAINER_INIT_COMMAND" ]; then
    echo "$(date +%FT%T%:z) ==> CONTAINER_INIT_COMMAND: $CONTAINER_INIT_COMMAND"
    $CONTAINER_INIT_COMMAND
fi


if [[ $# -eq 0 ]]; then
    exec "/bin/bash"
else
    for d in custom_nodes input models output; do
        if [ ! -d "$d" ]; then
            cp -r ~/ComfyUI/$d ./
        fi
    fi

    exec "$@"
fi
