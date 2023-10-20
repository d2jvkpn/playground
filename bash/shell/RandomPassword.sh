#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

length=${1:-16}
special=${special:-false}
clipboard=${clipboard:-false}
chars='0-9a-zA-Z'

[ "$special" == "true" ] && chars=$chars'!@#$%^&*()'

echo "==> chars: '$chars', length: $length, clipboard: $clipboard" >&2

if [ "$clipboard" == "true" ]; then
    password=$(tr -dc "$chars" < /dev/urandom | fold -w "$length" | head -n 1 || true)
    echo -n "$password" | xclip -selection c
else
    tr -dc "$chars" < /dev/urandom | fold -w "$length" | head -n 8 || true
fi
