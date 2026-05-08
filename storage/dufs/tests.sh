#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


####
url=$(yq .dufs.url configs/access.yaml)
username=$(yq .dufs.username configs/access.yaml)
password=$(yq .dufs.password configs/access.yaml)

token=$(printf "$username:$password" | base64 -w 0)

####
date +'%F%T%:z' > data/test.txt

curl -i -u "$username:$password" -T ./data/test.txt $url/test.txt  # 201
curl -i -u "$username:$password" -T ./data/test.txt $url/test.txt  # 403

curl -i $url/test.txt                                              # 200
curl -i -T ./data/test.txt $url/anonymous-test.txt                 # 401


####
curl -i -H "Authorization: Basic $token" \
  -X PUT \
  -H "Content-Type: text/plain" \
  -d @./data/test.txt $url/hello.txt

curl -i -H "Authorization: Basic $token" "$url"
curl -i -H "Authorization: Basic $token" "$url/?json"

curl -i -H "Authorization: Basic $token" -X DELETE "$url/test.txt"

curl -i -H "Authorization: Basic $token" -X MKCOL "$url/new-folder"

curl -i -H "Authorization: Basic $token" \
  -X MOVE \
  -H "Destination: $url/hello.txt" \
  "$url/new-folder/hello.txt"
