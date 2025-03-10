#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

input=$1
domain=${2:-$input}

if [[ "$input" == *".crt" || "$input" == *".cer" || "$input" == *".pem" ]]; then
    openssl x509 -in "$input" -noout -subject -ext subjectAltName -dates
else
    echo |
      openssl s_client -connect $input:443 -servername $domain -showcerts |
      #openssl s_client -connect $input:443 -servername $domain 2>/dev/null |
      openssl x509 -noout -subject -ext subjectAltName -dates
fi

exit
####
domain=domain.crt

openssl x509 -in $domain -noout -subject -ext subjectAltName -dates

openssl x509 -in $domain -noout -text

openssl crl2pkcs7 -nocrl -certfile $domain |
  openssl pkcs7 -print_certs -noout -text |
  grep "Subject: "

curl -vI https://$domain

curl -vI https://$domain --resolve "$domain:443:$ip"
