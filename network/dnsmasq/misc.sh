#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


getent hosts www.google.com
getent ahosts www.google.com

nslookup www.google.com 1.1.1.1

dig www.google.com @1.1.1.1 +short


curl --resolve www.google.com:443:142.251.153.119 https://www.google.com
