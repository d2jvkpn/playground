#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

exit
####
# read ssl of a site
echo | openssl s_client -servername example.com -connect example.com:443 | openssl x509 -text

# - `-servername example.com`: SNI（Server Name Indication）
# - `-connect example.com:443`: target host and port
# - `openssl x509 -text`: human readable text

exit
####
# save ssl of a site to file
echo | openssl s_client -servername example.com -connect example.com:443 |
  openssl x509 > example_com.crt

exit
####
openssl x509 -in tls.crt -noout -dates


#### get ssl info of a site
openssl s_client -connect example.domain:443 -servername \
  example.domain | openssl x509 -noout -text


openssl x509 -in <(kubectl get secret TLS_name -o jsonpath="{.data['tls\.crt']}" | base64 --decode) -text -noout

openssl rsa -in <(kubectl get secret TLS_name -o jsonpath="{.data['tls\.key']}" | base64 --decode) -check

# kubectl logs -l app.kubernetes.io/name=ingress-nginx -n namespace


openssl x509 -in your_certificate.crt -text -noout

# extract key and cert from pem
# -passin password
openssl pkey -in site.pem -out site.key.pem

#
openssl x509 -in site.pem -pubkey -noout -out site.pub.pem

# awk 'BEGIN {c=0;} /-----BEGIN CERTIFICATE-----/ {c++} { print > "cert" c ".pem"} /-----END CERTIFICATE-----/ {close("cert" c ".pem")}' yourfile.pem

# openssl rsa -in privatekey.pem -pubout -out publickey.pem

# show cert
openssl x509 -in site.pem -text -noout
