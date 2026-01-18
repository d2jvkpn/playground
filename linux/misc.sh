#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit

rclone mount sftp:/path/on/remote_dir \
  /path/to/local_dir \
  --cache-dir /path/to/cache_dir \
  --vfs-cache-mode full \
  --vfs-cache-max-size 300G \
  --vfs-cache-max-age 9999h \
  --vfs-write-back 10m \
  --vfs-read-ahead 256M \
  --allow-other --network-mode --umask 000
