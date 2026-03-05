#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
sudo apt install proxychains4

# /etc/proxychains.conf or ~/.proxychains/proxychains.conf:
# socks5 127.0.0.1 1080

proxychains -q psql "host=db.example.com port=5432 user=xxx dbname=yyy"

exit
ssh -N -L 15432:db.internal:5432 user@bastion
