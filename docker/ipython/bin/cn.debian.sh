#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

deb_src=/etc/apt/sources.list.d/debian.sources
ubuntu_src=/etc/apt/sources.list

if [ -f $deb_src ]; then
    cp $deb_src $deb_src.bk
    sed -i 's#http://deb.debian.org#https://mirrors.aliyun.com#' $deb_src
    exit
fi

exit
cp $ubuntu_src $ubuntu_src.bk
# cp ${_path}/cn.aliyun.sources.list

addr="http://mirrors.aliyun.com"

cat > $ubuntu_src << EOF
deb $addr/ubuntu/ jammy main restricted universe multiverse
deb-src $addr/ubuntu/ jammy main restricted universe multiverse

deb $addr/ubuntu/ jammy-security main restricted universe multiverse
deb-src $addr/ubuntu/ jammy-security main restricted universe multiverse

deb $addr/ubuntu/ jammy-updates main restricted universe multiverse
deb-src $addr/ubuntu/ jammy-updates main restricted universe multiverse

# deb $addr/ubuntu/ jammy-proposed main restricted universe multiverse
# deb-src $addr/ubuntu/ jammy-proposed main restricted universe multiverse

deb $addr/ubuntu/ jammy-backports main restricted universe multiverse
deb-src $addr/ubuntu/ jammy-backports main restricted universe multiverse
EOF

exit
# lsb_release -a
. /etc/os-release
