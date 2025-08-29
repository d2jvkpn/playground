#!/bin/bash
set -eu


USER_UID=${USER_UID:-"0"}
USER_GID=${USER_GID:-$USER_UID}

if [[ "$USER_UID" == "0" ]]; then
    "$@"
    exit 0
fi

USER_NAME=appuser

if ! getent group $USER_GID >/dev/null; then
    groupadd -g $USER_GID $USER_NAME
fi

if ! id -u $USER_NAME >/dev/null 2>&1; then
    useradd -m -s /bin/bash -u $USER_UID -g $USER_GID $USER_NAME
    chown -R appuser /home/appuser
fi

exec gosu $USER_NAME "$@"
