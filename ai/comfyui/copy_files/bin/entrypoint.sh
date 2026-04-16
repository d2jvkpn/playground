#!/bin/bash
set -eu


#if [ -f "/opt/container_init.sh" ]; then
#    echo "$(date +%FT%T%:z) ==> bash /opt/container_init.sh"
#    bash /opt/container_init.sh
#fi

COMFYUI_DISABLE_MANAGER=${COMFYUI_DISABLE_MANAGER:-"false"}

# if command -v bash >/dev/null 2>&1; then
if [[ $# -eq 0 ]]; then
    exec bash
elif [[ "$1" == "bash" || "$1" == "sh" ]]; then
    exec "$@"
else
    for d in custom_nodes input models output; do
        if [ ! -d "$d" ]; then
            cp -r ~/ComfyUI/$d ./
        fi
    fi

    if [[ "$COMFYUI_DISABLE_MANAGER" == "true" && -d custom_nodes/ComfyUI-Manager ]]; then
        mv custom_nodes/ComfyUI-Manager custom_nodes/ComfyUI-Manager.disabled
    elif [[ -d "custom_nodes/ComfyUI-Manager.disabled" ]]; then
        mv custom_nodes/ComfyUI-Manager.disabled custom_nodes/ComfyUI-Manager
    fi

    exec "$@"
fi
