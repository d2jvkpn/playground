#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


echo "aliyun.com: ali-{project}-[region][sn]"
echo "cloud.tencent.com: tce-{project}-[region][sn]"
echo "aws.amazon.com: aws-{project}-[region][sn]"

echo "aws-un-sh01"
echo "aws-ai-sh"

echo "aws-project-uat-jumpserver"
echo "aws-project-uat-frontend"
