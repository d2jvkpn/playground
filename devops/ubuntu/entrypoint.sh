#!/bin/bash
set -eu


USER_UID=${USER_UID:-"0"}
USER_GID=${USER_GID:-$USER_UID}

if [[ "$USER_UID" == "0" ]]; then
    "$@"
    exit 0
fi

if ! getent group "$USER_GID" >/dev/null; then
    groupadd -g "$USER_GID" appuser
fi

if ! id -u appuser >/dev/null 2>&1; then
    useradd -m -s /bin/bash -u "$USER_UID" -g "$USER_GID" appuser
    chown -R appuser:appuser /home/appuser
fi

exec gosu appuser "$@"


exit
#### Change the uid and gid of appuser
groupmod -o -g ${USER_GID} appuser
usermod -o -u $USER_UID -g $USER_GID appuser

#find /home -user 1000 -exec chown -h $USER_UID {} \;
#find /home -group 1000 -exec chgrp -h $USER_GID {} \;
chown -R $USER_UID:$USER_GID /home/appuser
