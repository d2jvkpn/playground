#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

input=$1
domain=${2:-$input}

if [[ "$input" == *".crt" || "$input" == *".cer" || "$input" == *".pem" ]]; then
    openssl x509 -in "$input" -noout -subject -ext subjectAltName -dates
else
    echo |
      openssl s_client -connect $input:443 -servername $domain 2>/dev/null |
      openssl x509 -noout -subject -ext subjectAltName -dates
fi

exit
####
openssl x509 -in domain.crt -noout -text

curl https://$domain --resolve "$domain:443:$ip"
