#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


ids=i-0011xxxx

aws ec2 describe-instances

aws --out=json ec2 start-instances --instance-ids $ids
aws --out=json ec2 stop-instances --force --instance-ids $ids
