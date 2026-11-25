#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


user=$1
PUID=$2
PGID=${3:-$PUID}


#id "$user"
#getent passwd "$user"
#getent group "$user"

#getent passwd 1000
#getent group 1000

groupmod -g "$PUID" "$user"
usermod -u "$PUID" -g "$PGID" "$user"

#find / -xdev -user OLD_UID -exec chown -h 1000 {} +
chown -R $PUID:$PGID /home/"$user"
