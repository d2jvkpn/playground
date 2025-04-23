#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


mkdir -p configs/certs

#### 1. 生成自签 CA 证书
openssl genrsa -out configs/certs/ca.key 4096

openssl req -x509 -new -nodes  -sha256 -days 3650 \
  -subj "/C=CN/ST=Shanghai/L=Shanghai/O=MyOrg/OU=Dev/CN=MyCA" \
  -key configs/certs/ca.key -out configs/certs/ca.crt


#### 2. 生成 Elasticsearch 私钥 + CSR
openssl genrsa -out configs/certs/es.key 4096

openssl req -new \
  -subj "/C=CN/ST=Shanghai/L=Shanghai/O=MyOrg/OU=Dev/CN=es.local" \
  -key configs/certs/es.key -out configs/certs/es.csr


#### 3. 写一个 SAN 配置文件
cat > configs/certs/es-san.cnf <<EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[req_distinguished_name]
C = CN           # Country
ST = Shanghai    # State
L = Shanghai     # Locality
O = MyCompany    # Organization
OU = DevOps      # Organizational Unit
CN = es.local    # Common Name

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = es.local
DNS.2 = localhost
IP.1 = 127.0.0.1
IP.2 = 192.168.1.100
EOF


#### 4. 用 CA 签发证书
# ca.crt: 根证书（客户端需要信任它）, es.crt: Elasticsearch 用的服务端证书, es.key: 私钥

openssl x509 -req -CAcreateserial -days 365 -sha256 -extensions v3_req \
  -extfile configs/certs/es-san.cnf \
  -in configs/certs/es.csr -CA configs/certs/ca.crt \
  -CAkey configs/certs/ca.key -out configs/certs/es.crt 


#### 5. 配置 Elasticsearch 使用 OpenSSL 生成的证书
docker run -d --name es01 \
  -v $PWD/configs/certs:/usr/share/elasticsearch/config/certs \
  -e "discovery.type=single-node" \
  -e "xpack.security.enabled=true" \
  -e "xpack.security.http.ssl.enabled=true" \
  -e "xpack.security.http.ssl.certificate=config/certs/es.crt" \
  -e "xpack.security.http.ssl.key=config/certs/es.key" \
  -e "xpack.security.http.ssl.certificate_authorities=config/certs/ca.crt" \
  -p 9200:9200 \
  docker.elastic.co/elasticsearch/elasticsearch:9.0.0


#### 6. 访问测试
curl --cacert configs/certs/ca.crt https://192.168.1.100:9200 -u elastic:yourpassword
