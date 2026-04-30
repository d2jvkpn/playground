#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
password="$(openssl rand -base64 24)"
echo "Password: $password"
echo "Hash: $(openssl passwd -6 "$password")"

dufs --config configs/dufs.yaml

curl -i http://127.0.0.1:5000/public/test.txt

echo "hello dufs" > data/test.txt
curl -i -u admin:plain_password -T ./data/test.txt http://127.0.0.1:5000/public/test.txt

curl -i http://127.0.0.1:5000/public/test.txt

curl -i -T ./data/test.txt http://127.0.0.1:5000/public/anonymous-test.txt

curl -i -u admin:plain_password http://127.0.0.1:5000/public/
