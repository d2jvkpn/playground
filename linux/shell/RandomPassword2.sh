#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

length=${1:-16}


chars_uppercase="ABCDEFGHJKLMNPQRSTUVWXYZ" # A-Z
chars_lowercase="abcdefghijkmnpqrstuvwxyz" # a-z
numbers="23456789" # 0-9
special='!@#$%^&*()' # '!@#$%^&*()_+{}|:<>?='
# 24+24+7
# base58: 123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz

tr -dc "${chars_uppercase}${chars_lowercase}${numbers}" < /dev/urandom |
  fold -w "$length" | head -n 4 || true
echo

tr -dc "${chars_uppercase}${chars_lowercase}${numbers}${special}" < /dev/urandom |
  fold -w "$length" | head -n 4 || true
