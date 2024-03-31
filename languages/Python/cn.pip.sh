#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

pip3 config set global.index-url 'https://pypi.tuna.tsinghua.edu.cn/simple'
pip3 config set install.trusted-host 'pypi.tuna.tsinghua.edu.cn'

python3 -m pip install --upgrade pip

# /etc/pip.conf
cat > ~/.config/pip/pip.conf <<EOF
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
target = ~/.local/lib/python3.10/site-packages/

[install]
trusted-host = pypi.tuna.tsinghua.edu.cn
EOF


exit

pip3 config set global.index-url 'https://pypi.douban.com/simple/'
pip3 config set install.trusted-host 'pypi.douban/simple'

pip3 config list
pip3 install pandas numpy polars

exit
# /etc/pip.conf
cat > ~/.config/pip/pip.conf <<EOF
[global]
index-url = https://pypi.douban.com/simple/
target = ~/.local/lib/python3.10/site-packages/

[install]
trusted-host = pypi.douban/simple
EOF
