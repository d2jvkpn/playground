#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

sed -i '/trust$/s/trust$/scram-sha-256/' pg_hba.conf

cat >> pg_hba.conf <<EOF
# Add settings for extensions here
host    all    postgres    127.0.0.1/32    trust
host    all    postgres    ::1/128         trust
EOF
