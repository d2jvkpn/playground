#!/usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


exit

referer=https://SITE.DOMAIN
url=https://SITE.DOMAIN/path/to/resource
output=resource.data
UA="User-Agent: Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36"

wget -x socks5h://localhost:1081 --header="Referer: $referer" --header="$UA" $url -O $output
