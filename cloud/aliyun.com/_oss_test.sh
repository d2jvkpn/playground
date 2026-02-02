#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

mkdir -p data

echo "Hello, world" > data/hello.txt

exit
bucket=""
region=cn-shanghai

access_key_id="xxxxxxxx"
access_key_secret="yyyyyyyy"


ossutil cp -f data/hello.txt \
  "oss://$bucket/tests/hello.txt" \
  --access-key-id "$access_key_id" --access-key-secret "$access_key_secret" \
  --endpoint oss-${region}.aliyuncs.com --region $region

# oss-${region}-internal.aliyuncs.com

echo https://$bucket.oss-${region}-internal.aliyuncs.com/tests/hello.txt
