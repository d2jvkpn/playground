#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


user_uid=$1
user_gid=${2:-$user_uid}


#id appuser
#getent passwd appuser
#getent group appuser

#getent passwd 1000
#getent group 1000

groupmod -g "$user_uid" appuser
usermod -u "$user_uid" -g "$user_gid" appuser

#find / -xdev -user OLD_UID -exec chown -h 1000 {} +
chown -R $user_uid:$user_gid /home/appuser
