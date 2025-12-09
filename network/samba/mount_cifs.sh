#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


yaml=${1:-configs/local.yaml}

username=$(yq .samba.username $yaml)
password=$(yq .samba.password $yaml)
ip=$(yq .samba.ip $yaml)

remote_dir=$(yq .samba.remote_dir $yaml)
local_dir=$(yq .samba.local_dir $yaml)
mkdir -p "$local_dir"
local_dir=$(readlink -f "$local_dir")

# crontab: */1 * * * * bash /root/cron/mount_cifs.sh # check every 1min
# exit if the path is alread mounted, timeout 10s
# $ mountpoint "$local_dir" && exit 0

# timeout 10s
sudo mount -t cifs \
  -o username=$username,password=$password,vers=2.0,sec=ntlmssp \
  //$ip$remote_dir $local_dir
