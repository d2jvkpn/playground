#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

exit
# read ssl of a site
echo | openssl s_client -servername example.com -connect example.com:443 | openssl x509 -text

# - `-servername example.com`: SNI（Server Name Indication）
# - `-connect example.com:443`: target host and port
# - `openssl x509 -text`: human readable text

exit
# save ssl of a site to file
echo | openssl s_client -servername example.com -connect example.com:443 |
  openssl x509 > example_com.crt


exit
openssl x509 -in tls.crt -noout -dates
