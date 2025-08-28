#!/bin/bash
set -eu -o pipefail


export DEBIAN_FRONTEND=noninteractive

#apt-get -qq update 2>&1 > /dev/null
apt-get -qq update
apt-get upgrade -qq -y --no-install-recommends

if [ $# -gt 0 ]; then
    apt install -y --no-install-recommends "$@"
fi

apt autoremove && apt clean && apt autoclean

dpkg -l | awk '/^rc/{print $2}' | xargs -i dpkg -P {}

rm -rf /var/lib/apt/lists/*
