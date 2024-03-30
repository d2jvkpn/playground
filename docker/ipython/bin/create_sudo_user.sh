#!/bin/bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

username=$1

# -u 1000
useradd -m -s /bin/bash $username
usermod -aG sudo $username

mkdir -p /etc/sudoers.d
echo "$username ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$username
