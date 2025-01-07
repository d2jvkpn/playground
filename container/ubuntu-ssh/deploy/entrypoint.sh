#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

status_dir=/root/apps/status
initialized=openssh-server.initialized

if [ ! -s $status_dir/$initialized ]; then
    dpkg-reconfigure openssh-server
    mkdir -p $status_dir
    echo "yes" > $status_dir/$initialized
fi

# exec "$@"
/usr/sbin/sshd -D
