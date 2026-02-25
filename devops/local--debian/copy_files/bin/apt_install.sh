#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


#### 1. setup
export DEBIAN_FRONTEND=noninteractive

#### 2. upgrade
apt-get -qq update 2>&1 > /dev/null

apt list --upgradable 2>/dev/null |
  awk -F "/" 'NF>1{print $1}' |
  xargs apt upgrade -qq -y --no-install-recommends --allow-change-held-packages
# apt-get upgrade -qq -y --no-install-recommends

#### 3. install packages
if [ $# -gt 0 ]; then
    apt install -y --no-install-recommends "$@"
fi

#### 4. clean up
apt autoremove && apt clean && apt autoclean
dpkg -l | awk '/^rc/{print $2}' | xargs -i dpkg -P {}
rm -rf /var/lib/apt/lists/*
