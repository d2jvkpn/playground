#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


# cron: 0 0 * * * bash ${HOME}/apps/acme.git/acme.sh --cron --server letsencrypt
acme_dir=${acme_dir:-~/apps/acme}
domain="$1"

# curl https://get.acme.sh | sh
if [ ! -s $acme_dir/acme.sh ]; then
    git clone https://github.com/acmesh-official/acme.sh $acme_dir
fi

yaml=~/apps/configs/acme.yaml
ls "$yaml" > /dev/null

# email=john@doe.local; domain=doe.local
key=$(yq .aliyun.key "$yaml" | sed 's/^null$//')
secret=$(yq .aliyun.secret "$yaml" | sed 's/^null$//')
email=$(yq .aliyun.email "$yaml" | sed 's/^null$//')

[[ -z "$email" || -z "$domain" ]] && { &>2 echo "email or domain is unset"; exit 1; }

if [[ -z "$key" || -z "$secret" ]]; then
    &>2 echo "aliyun.key or aliyun.secret is unset"
    exit 1
fi

#### 1. installation
mkdir -p ~/apps/crons

$acme_dir/acme.sh --register-account --home $acme_dir -m $email

#### 2. setup account
# account permissions: ["AliyunDNSFullAccess"]
export Ali_Key="$key" Ali_Secret="$secret"

$acme_dir/acme.sh --issue --server letsencrypt --home $acme_dir \
  --dns dns_ali -d "$domain" -d "*.$domain"

exit
cat $acme_dir/account.conf
# SAVED_Ali_Key='xxxx'
# SAVED_Ali_Secret='xxxx'

#### 3. setup cron
# crontab -l; crontab -e
# 0 0 * * * ~/apps/crons/acme_cron.sh
