#!//bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

mkdir -p configs

subjects="/O=MyCompany/ST=MyState/L=MyCity/C=CN"

set -x
#### opensearch-root
openssl genrsa -out configs/opensearch-root-ca.key 2048

openssl req -new -x509 -sha256 -days 730 -subj "/CN=opensearch-root" \
  -key configs/opensearch-root-ca.key -out configs/opensearch-root-ca.crt

#### opensearch-dashboards
openssl genrsa -out configs/opensearch-dashboards.key 2048

openssl req -new -subj "$subjects/CN=opensearch-dashboards" \
  -key configs/opensearch-dashboards.key -out configs/opensearch-dashboards.csr

openssl x509 -req -days 730 -sha256 -CAcreateserial \
  -CA configs/opensearch-root-ca.crt -CAkey configs/opensearch-root-ca.key  \
  -in configs/opensearch-dashboards.csr  -out configs/opensearch-dashboards.crt

#### opensearch-node01
openssl genrsa -out configs/opensearch-node01.key 2048

openssl req -new -subj "$subjects/CN=opensearch-node01" \
  -key configs/opensearch-node01.key -out configs/opensearch-node01.csr

openssl x509 -req -days 730 -sha256 -CAcreateserial \
  -CA configs/opensearch-root-ca.crt -CAkey configs/opensearch-root-ca.key  \
  -in configs/opensearch-node01.csr  -out configs/opensearch-node01.crt

#### opensearch-node02
openssl genrsa -out configs/opensearch-node02.key 2048

openssl req -new -subj "$subjects/CN=opensearch-node02" \
  -key configs/opensearch-node02.key -out configs/opensearch-node02.csr

openssl x509 -req -days 730 -sha256 -CAcreateserial \
  -CA configs/opensearch-root-ca.crt -CAkey configs/opensearch-root-ca.key  \
  -in configs/opensearch-node02.csr  -out configs/opensearch-node02.crt
