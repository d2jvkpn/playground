#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


echo "aliyun.com: ali-{project}-[region][sn]"
echo "cloud.tencent.com: tce-{project}-[region][sn]"
echo "aws.amazon.com: aws-{project}-[region][sn]"

echo "aws-s01-tk"
echo "aws-s02-sh"

echo "aws-project-dev-backend"
echo "aws-project-test-backend"
echo "aws-project-sit-backend"
echo "aws-project-uat-backend"
echo "aws-project-prod-backend"
