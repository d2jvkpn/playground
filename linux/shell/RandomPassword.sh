#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

if [[ $# -gt 0 && ("$1" == "help" || "$1" == "-h" || "$1" == "--help") ]]; then
    >&2 echo 'Default parameters of RandomPassword.sh:
- length($1): 16
- special(env): false
- clipboard(env): false
- chars(env): 0-9a-zA-Z'
    exit 2
fi

length=${1:-16}
special=${special:-false}
clipboard=${clipboard:-false}
chars=${chars:-"0-9a-zA-Z"}

[ "$special" == "true" ] && chars=$chars'!@#$%^&*()'

>&2 echo "==> length: $length, chars: '$chars', clipboard: $clipboard"

passwords=$(
    tr -dc "$chars" < /dev/urandom |
      fold -w "$length" |
      sed 's/\(.\)\1\+/\1/g' |
      tr -d '\n' |
      fold -w "$length" |
      head -n 8 || true
)

if [ "$clipboard" == "true" ]; then
    password=$(echo "$passwords" | head -n 1 || true)
    echo -n "$password" | xclip -selection c
else
   echo "$passwords"
fi
