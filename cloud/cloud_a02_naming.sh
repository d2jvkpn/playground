#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0)


echo "aliyun.com: ali-{project}--[region][sn]"
echo "cloud.tencent.com: tce-{project}--[region][sn]"
echo "aws.amazon.com: aws-{project}--[region][sn]"

echo "aws-ai--sh-01"
echo "aws-un--sh-01"
