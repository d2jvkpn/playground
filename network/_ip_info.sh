#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
#### international
curl -4 ifconfig.me
curl -4 icanhazip.com
curl ipinfo.io


#### cn
curl 4.ipw.cn
curl 6.ipw.cn
curl test.ipw.cn
curl http://myip.ipip.net
