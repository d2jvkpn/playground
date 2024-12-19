#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0)


echo "aliyun.com: ali-{region}-{project}-{sn}"
echo "cloud.tencent.com: tce-{region}-{project}-{sn}"
echo "aws.amazon.com: aws-{region}-{project}-{sn}"

echo "ali-sh-company-a01" "ali-hk-xx-a01"
