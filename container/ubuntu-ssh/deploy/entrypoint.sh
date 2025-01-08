#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

dpkg-reconfigure openssh-server

# exec "$@"
/usr/sbin/sshd -D
