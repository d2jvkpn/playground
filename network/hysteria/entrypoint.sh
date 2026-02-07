#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

APPUSER_UID=${APPUSER_UID:-"0"}
APPUSER_GID=${APPUSER_GID:-$APPUSER_UID}

if [ -s "/opt/init.sh" ]; then
    bash /opt/init.sh
fi

if [[ "$APPUSER_UID" == "0" ]]; then
    exec "$@"
    exit 0
fi

if ! getent group $APPUSER_GID >/dev/null 2>&1; then
    addgroup -g $APPUSER_GID -S appuser
fi

if ! getent passwd $APPUSER_UID >/dev/null 2>&1; then
    adduser -u $APPUSER_UID -S -G appuser -h /home/appuser appuser #-H
fi

chown $APPUSER_UID:$APPUSER_GID /home/workspace /home/workspace/*

#exec gosu $APPUSER_UID:$APPUSER_GID "$@"
exec "$@"
