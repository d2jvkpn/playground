#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit ???
apt install -y locales vim fonts-noto-cjk
locale-gen en_US.UTF-8 zh_CN.UTF-8
update-locale LANG=en_US.UTF-8
export LANG=en_US.UTF-8

# $ locale
#LANG=en_US.UTF-8
#LC_ALL=


exit

cat >> /etc/vim/vimrc <<EOF
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312
set termencoding=utf-8
set ambiwidth=double
EOF
