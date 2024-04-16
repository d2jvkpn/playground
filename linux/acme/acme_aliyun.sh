#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

yaml=$1; ls $yaml > /dev/null

# email=john@doe.local; domain=doe.local
email=$(yq .email $yaml)
domain=$(yq .domain $yaml)
key_id=$(yq .access_key_id $yaml)
key_secret=$(yq .access_key_secret $yaml)

[[ -z "$email" || -z "$domain" ]] && { &>2 echo "email or domain is unset"; exit 1; }

if [[ -z "$key_id" || -z "$key_secret" ]]; then
    &>2 echo "aliyun.access_key_id or aliyun.access_key_secret is unset"
    exit 1
fi

#### 1. installation
mkdir -p ~/Apps ~/crons

# curl https://get.acme.sh | sh
[ -s ~/Apps/acme/acme.sh ] || git clone https://github.com/acmesh-official/acme.sh ~/Apps/acme

~/Apps/acme/acme.sh --register-account --home ~/Apps/acme -m $email

#### 2. setup account
# account permissions: ["AliyunDNSFullAccess"]
export Ali_Key="$key_id" Ali_Secret="$key_secret"

~/Apps/acme/acme.sh --issue --server letsencrypt --home ~/Apps/acme \
  --dns dns_ali -d "$domain" -d "*.$domain"

cat ~/Apps/acme/account.conf
# SAVED_Ali_Key='xxxx'
# SAVED_Ali_Secret='xxxx'

#### 3. setup cron
# crontab -l; crontab -e
# 0 0 * * * ~/crons/acme_cron.sh
