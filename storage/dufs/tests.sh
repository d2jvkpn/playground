#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


url=$(yq .dufs.url configs/access.yaml)
username=$(yq .dufs.username configs/access.yaml)
password=$(yq .dufs.password configs/access.yaml)


date +'%F%T%:z' > data/test.txt

curl -i -u "$username:$password" -T ./data/test.txt $url/test.txt  # 201

curl -i $url/test.txt                                              # 200

curl -i -T ./data/test.txt $url/anonymous-test.txt                 # 401
