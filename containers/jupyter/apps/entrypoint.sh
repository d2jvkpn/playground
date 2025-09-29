#!/bin/bash
set -eu

USER_UID=${USER_UID:-"0"}
USER_GID=${USER_GID:-$USER_UID}

if [[ "$USER_UID" == "0" ]]; then
    "$@"
    exit 0
fi

if ! getent group $USER_GID >/dev/null 2>&1; then
    groupadd -g $USER_GID appuser
fi

#if ! id -u appuser >/dev/null >/dev/null 2>&1; then
if ! getent passwd $USER_UID >/dev/null 2>&1; then
    useradd -s /bin/bash -m -u $USER_UID -g $USER_GID appuser
    chown -R $USER_UID:$USER_GID /home/appuser
fi

exec gosu $USER_UID:$USER_GID "$@"
