#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


openssl s_client -connect domain.example.com:443 -servername domain.example.com -showcerts
