#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

# https://nginx.org/en/docs/http/ngx_http_log_module.html

nginx -t
nginx -s reload
