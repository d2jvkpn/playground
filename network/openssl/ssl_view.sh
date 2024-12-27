#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0) # set -x

domain=$1
host=${2:-$domain}

echo |
  openssl s_client -connect $host:443 -servername $domain 2>/dev/null |
  openssl x509 -noout -subject -dates

# openssl x509 -noout -text

exit
#### view file
openssl x509 -in domain.crt -noout -text
openssl x509 -in domain.crt -noout -subject -dates

exit
#### view the service
echo | openssl s_client -connect localhost:443 -servername $domain |
  openssl x509 -noout -subject -dates

####
curl https://$domain --resolve "$domain:443:$ip"
