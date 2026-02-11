#!bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


server_ip=${server_ip:-127.0.0.1}

mkdir -p configs

cat > configs/frp_openssl.cnf << EOF
[ ca ]
default_ca = CA_default
[ CA_default ]
x509_extensions = usr_cert
[ req ]
default_bits        = 2048
default_md          = sha256
default_keyfile     = privkey.pem
distinguished_name  = req_distinguished_name
attributes          = req_attributes
x509_extensions     = v3_ca
string_mask         = utf8only
[ req_distinguished_name ]
[ req_attributes ]
[ usr_cert ]
basicConstraints       = CA:FALSE
nsComment              = "OpenSSL Generated Certificate"
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid,issuer
[ v3_ca ]
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints       = CA:true
EOF

#### build ca certificates
openssl genrsa -out configs/frp_ca.key 2048

openssl req -x509 -new -nodes \
  -subj "/CN=ca.frp.localhost" -days 5000 \
  -key configs/frp_ca.key -out configs/frp_ca.crt

# C (Country)
# ST (State)
# L (Locality)
# O (Organization)
# CN (Common Name)
#### build frps certificates
openssl genrsa -out configs/frp_server.key 2048

openssl req -new -sha256 -reqexts SAN \
  -subj "/C=XX/ST=DEFAULT/L=DEFAULT/O=DEFAULT/CN=server.frp.localhost" \
  -config <(cat configs/frp_openssl.cnf <(printf "\n[SAN]\nsubjectAltName=DNS:localhost,IP:${server_ip}")) \
  -key configs/frp_server.key -out configs/frp_server.csr

openssl x509 -req -days 365 -sha256 -CAcreateserial \
  -extfile <(printf "subjectAltName=DNS:localhost,IP:${server_ip}") \
  -CA configs/frp_ca.crt -CAkey configs/frp_ca.key \
  -in configs/frp_server.csr -out configs/frp_server.crt

#### build frpc certificates
openssl genrsa -out configs/frp_client.key 2048

openssl req -new -sha256 -reqexts SAN \
  -config <(cat configs/frp_openssl.cnf <(printf "\n[SAN]\nsubjectAltName=DNS:localhost")) \
  -subj "/C=XX/ST=DEFAULT/L=DEFAULT/O=DEFAULT/CN=client.frp.localhost" \
  -key configs/frp_client.key -out configs/frp_client.csr

openssl x509 -req -days 365 -sha256 -CAcreateserial \
  -extfile <(printf "subjectAltName=DNS:localhost") \
  -CA configs/frp_ca.crt -CAkey configs/frp_ca.key \
  -in configs/frp_client.csr -out configs/frp_client.crt
