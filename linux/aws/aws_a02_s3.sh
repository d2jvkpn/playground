#!/usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

bucket=BUCKET01

####
aws configure list

####
aws s3 ls s3://$bucket/  --recursive

echo "Hello, world!" > hello_world.txt
aws s3 cp hello_world.txt s3://$bucket/

aws s3 mv s3://$bucket/hello_world.txt s3://$bucket/temp/hello_world.txt

aws s3 ls s3://$bucket/temp/hello_world.txt
aws s3 rm s3://$bucket/temp/hello_world.txt
aws s3 presign s3://$bucket/hello_world.txt

# http://$bucket.s3-website-ap-northeast-1.amazonaws.com/test/index.html

aws s3 cp html s3://$bucket/test/html --recursive
