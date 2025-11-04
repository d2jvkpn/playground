#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


uid=2000
gid=2000

groupmod -g $gid appuser
usermod -u $uid -g $gid appuser

#find / -user 1000 -exec chown -h 2000 {} \;
#find / -group 1000 -exec chgrp -h 2000 {} \;

chown -R $uid:$gid /home/appuser
