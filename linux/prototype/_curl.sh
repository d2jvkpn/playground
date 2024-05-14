#!/usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

exit
curl -x socks5h://127.0.0.1:1081 $*

exit
url=$1
curl -fs -X Head $url || echo $url


# -H "Date: $(date -u +"%a, %d %b %Y %H:%M:%S GMT")"


curl --silent --output $OUTPUT_FILE --write-out "%{http_code}" "$@"

curl --fail
