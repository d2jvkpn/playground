#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

apt clean
apt autoclean
apt remove
apt autoremove
dpkg -l | awk '/^rc/{print $2}' | xargs -i sudo dpkg -P {}

####
exit 0
snap list
sudo snap remomve --purge core22
sudo snap remove --purge snapd
