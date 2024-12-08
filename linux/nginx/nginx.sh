#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# https://nginx.org/en/docs/http/ngx_http_log_module.html

nginx -t
nginx -s reload
