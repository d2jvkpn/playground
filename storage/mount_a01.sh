#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
dufs mount <remote_path> <local_mount_point> --option1=value1

mount -t nfs <dufs_server>:/volume /local/path

exit
sudo apt install davfs2
sudo mount -t davfs http://server-ip:5000/ /mnt/dufs

exit
#compose.yaml
devices:
- /dev/fuse:/dev/fuse
cap_add:
- SYS_ADMIN
security_opt:
- apparmor:unconfined

exit
sudo apt install fuse-overlayfs
