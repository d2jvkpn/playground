#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

exit

#### rclone for aliyun oss
# https://help.aliyun.com/zh/oss/developer-reference/mount-oss-buckets-to-local-file-systems-by-using-amazon-s3-protocols

cat > ~/.config/rclone/rclone.conf <<EOF
[oss_bucket]
type = s3
provider = Alibaba
access_key_id = xxxxxxxx
secret_access_key = yyyyyyyy
endpoint = oss-cn-shanghai-internal.aliyuncs.com
acl = private
EOF

rclone mount \
  oss_bucket:/ \
  /path/to/local_dir \
  --cache-dir /path/to/cache_dir \
  --vfs-cache-mode writes \
  --vfs-cache-max-size 100G \
  --vfs-cache-max-age 168h \
  --vfs-write-back 10m \
  --vfs-read-ahead 256M \
  --dir-cache-time 72h \
  --network-mode \
  --allow-other \
  --multi-thread-streams 4 \
  --s3-upload-concurrency 4

fusermount -uz /path/to/local_dir

#### sftp
rclone mount \
  sftp:/path/of/remote_dir \
  /path/to/local_dir \
  --cache-dir /path/to/cache_dir \
  --vfs-cache-mode full \
  --vfs-cache-max-size 100G \
  --vfs-cache-max-age 168h \
  --vfs-write-back 10m \
  --vfs-read-ahead 256M \
  --dir-cache-time 72h \
  --network-mode \
  --allow-other

#### external storage
/usr/bin/rclone mount \
  usb:/mnt/disk01 \
  /path/to/local_dir \
  --cache-dir /path/to/cache_dir \
  --vfs-cache-mode full \
  --vfs-cache-max-size 100G \
  --vfs-cache-max-age 72h \
  --vfs-write-back 10m \
  --dir-cache-time 72h \
  --allow-other
