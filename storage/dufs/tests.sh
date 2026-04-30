#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


####
url=$(yq .dufs.url configs/access.yaml)
username=$(yq .dufs.username configs/access.yaml)
password=$(yq .dufs.password configs/access.yaml)

####
date +'%F%T%:z' > data/test.txt

curl -i -u "$username:$password" -T ./data/test.txt $url/test.txt  # 201
curl -i -u "$username:$password" -T ./data/test.txt $url/test.txt  # 403

curl -i $url/test.txt                                              # 200

curl -i -T ./data/test.txt $url/anonymous-test.txt                 # 401

####
token=$(printf "$username:$password" | base64 -w 0)

curl -i -X PUT \
  -H "Authorization: Basic $token" \
  -H "Content-Type: text/plain" \
  -d @./data/test.txt $url/hello.txt
