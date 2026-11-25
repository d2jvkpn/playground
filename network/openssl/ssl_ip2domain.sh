ip=$1

openssl s_client -connect "${ip}":443 2>/dev/null | openssl x509 -noout -subject
