#! /usr/bin/env bash
set -eu -o pipefail
# set -x
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

if [ $# -gt 0 ]; then
    >&2 echo 'RandomPassword.sh default parameters:
    length: 16, special: false, clipboard: false, chars: "0-9a-zA-Z"'
    exit 2
fi

length=${length:-16}
special=${special:-false}
clipboard=${clipboard:-false}
chars=${chars:-"0-9a-zA-Z"}

[ "$special" == "true" ] && chars=$chars'!@#$%^&*()'

>&2 echo "==> chars: '$chars', length: $length, clipboard: $clipboard"

if [ "$clipboard" == "true" ]; then
    password=$(tr -dc "$chars" < /dev/urandom | fold -w "$length" | head -n 1 || true)
    echo -n "$password" | xclip -selection c
else
    tr -dc "$chars" < /dev/urandom | fold -w "$length" | head -n 8 || true
fi
