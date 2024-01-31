#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

export DEBIAN_FRONTEND=nointeractive

apt update && apt -y upgrade
# reboot
apt clean && apt -y autoclean
apt remove && apt -y autoremove

dpkg -l | awk '/^rc/{print $2}' | xargs -i dpkg -P {}
