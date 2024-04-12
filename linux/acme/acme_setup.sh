#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

#### 1. installation
mkdir -p ~/Apps ~/crons
git clone https://github.com/acmesh-official/acme.sh ~/Apps/acme
# curl https://get.acme.sh | sh

~/Apps/acme/acme.sh --register-account -m $email

#### 2. setup account

##### 2.1 dns aliyun
# account permissions: AliyunDNSFullAccess
email=john@doe.local
domain=doe.local

# get access key https://ram.console.aliyun.com/manage/ak
export Ali_Key="xxxx" Ali_Secret="yyyy"

~/Apps/acme/acme.sh --issue --server letsencrypt --home ~/Apps/acme --dns dns_ali \
  -d "$domain" -d "*.$domain"

cat ~/Apps/acme/account.conf
# SAVED_Ali_Key='xxxx'
# SAVED_Ali_Secret='xxxx'

#### 3. setup cron
# crontab -l; crontab -e
# 0 0 * * * ~/crons/acme_cron.sh
