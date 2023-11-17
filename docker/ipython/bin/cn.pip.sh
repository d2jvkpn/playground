#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

pip3 config set global.index-url 'https://pypi.douban.com/simple/'
pip3 config set install.trusted-host 'pypi.douban/simple'

exit
# /etc/pip.conf
cat > ~/.config/pip/pip.conf <<EOF
[global]
index-url = https://pypi.douban.com/simple/

[install]
trusted-host = pypi.douban/simple
EOF
