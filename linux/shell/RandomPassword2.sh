#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(readlink -f `dirname "$0"`)


length=${1:-16}

uppercase="ABCDEFGHJKLMNPQRSTUVWXYZ" # A-Z
lowercase="abcdefghijkmnpqrstuvwxyz" # a-z
numbers="23456789" # 0-9
special='!@#$%^&*()' # '!@#$%^&*()_+{}|:<>?='
# 24+24+7
# base58: 123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz

tr -dc "${uppercase}${lowercase}${numbers}" < /dev/urandom |
  fold -w "$length" | head -n 4 || true

echo

tr -dc "${uppercase}${lowercase}${numbers}${special}" < /dev/urandom |
  fold -w "$length" | head -n 4 || true
