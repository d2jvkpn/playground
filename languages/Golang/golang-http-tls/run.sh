#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### tls
mkdir -p configs

# openssl req -new -newkey rsa:2048 -nodes -out configs/localhost.csr -keyout configs/localhost.key

openssl genrsa -out configs/server.key 2048

openssl req -new \
  -subj "/CN=example.com/O=My Organization/C=US" \
  -key configs/server.key \
  -out configs/server.csr

openssl x509 -req -days 365 \
  -in configs/server.csr \
  -signkey configs/server.key \
  -out configs/server.crt

# using server.key and server.crt for TLS encryption

#### service
go run main.go &

#### test
curl -k https://localhost:8443/
