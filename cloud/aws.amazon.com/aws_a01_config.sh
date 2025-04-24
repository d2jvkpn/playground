#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


cat > ~/.aws/credentials << EOF
[default]
region = ap-northest-1
output = yaml
aws_access_key_id = xxxx
aws_secret_access_key = yyyyyyyy
EOF
