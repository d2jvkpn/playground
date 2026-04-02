#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


user=mysql
target_uid=1001

exit
old_uid=$(id $user)
getent passwd $user

pkill -u $user

usermod -u $target_uid $user
groupmod -g $target_uid $user

sudo find /home/$user -user $old_uid -exec chown -h $target_uid {} \;
sudo find /home/$user -group $old_uid -exec chgrp -h $target_uid {} \;

sudo find / -xdev -user 1000 -exec chown -h $target_uid {} \;
sudo find / -xdev -group 1000 -exec chgrp -h $target_uid {} \;
