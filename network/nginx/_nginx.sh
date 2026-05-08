#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

# https://nginx.org/en/docs/http/ngx_http_log_module.html

nginx -t
nginx -s reload



journalctl -u nginx.service
journalctl -u nginx.service -f
journalctl -u nginx.service --since today
journalctl -u nginx.service --since "2023-10-01" --until "2023-10-02"
journalctl -u nginx.service -n 100
journalctl -u nginx.service --reverse
