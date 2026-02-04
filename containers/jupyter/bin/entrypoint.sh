#!/bin/bash
set -eu

APPUSER_UID=${APPUSER_UID:-"0"}
APPUSER_GID=${APPUSER_GID:-$APPUSER_UID}

# echo "$(date +%FT%T%:z) ==> entrypoint.sh"
if [ -s "/opt/init.sh" ]; then
    bash /opt/init.sh
fi

if [[ "$APPUSER_UID" == "0" ]]; then
    exec "$@"
    exit 0
fi

if ! getent group $APPUSER_GID >/dev/null 2>&1; then
    groupadd -g $APPUSER_GID appuser
fi

#if ! id -u appuser >/dev/null >/dev/null 2>&1; then
#if ! getent passwd $APPUSER_UID >/dev/null 2>&1; then ... fi
useradd -s /bin/bash -m -u $APPUSER_UID -g $APPUSER_GID appuser
#chown -R $APPUSER_UID:$APPUSER_GID /home/appuser
#chown "$APPUSER_UID:$APPUSER_GID" /home/appuser
#find /home/appuser -xdev -mindepth 1 -maxdepth 1 -exec chown -R "$APPUSER_UID:$APPUSER_GID" {} +
for d in $(echo $APPUSER_DIRS | sed 's/,/ /g'); do
    chown -R appuser:appuser $d
done

exec gosu $APPUSER_UID:$APPUSER_GID "$@"
