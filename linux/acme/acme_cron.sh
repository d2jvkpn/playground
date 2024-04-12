#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {} )

# cron: 0 0 * * * bash ${HOME}/crons/acme_cron.sh YourDomain
domain=$1

acme=~/Apps/acme # directory
certs_dir=$acme/${domain}_ecc
target_dir=~/nginx/certs

{
    date +"==> %FT%T%:z run acme_cron.sh"
    s1=$(md5sum $certs_dir/$domain.cer | awk '{print $1}')

    ${acme}/acme.sh --cron --server letsencrypt --home $acme

    s2=""
    [ -f $target_dir/$domain.cer ] && s2=$(md5sum $target_dir/$domain.cer | awk '{print $1}')

    if [[ "$s1" != "$s2" ]]; then
        date +"--> %FT%T%:z renew ssl and reload nginx"
        rsync ${certs_dir}/$domain.{key,cer} $target_dir/
        sudo nginx -t
        sudo nginx -s reload
    fi
} >> ${_path}/acme_cron.$(date +"%Y-%m").log 2>&1


exit

#### 1. installation
mkdir -p ~/Apps
git clone https://github.com/acmesh-official/acme.sh ~/Apps/acme

# curl https://get.acme.sh | sh

mkdir -p ~/crons
cp acme_cron.sh ~/crons

~/Apps/acme/acme.sh --register-account -m $email

#### 2. setup account

##### 2.1 dns aliyun
# aliyun_account01_permissions=["AliyunDNSFullAccess"]
access_key_file=aliyun_account01.json
email=john@doe.local
domain=doe.local

# get access key https://ram.console.aliyun.com/manage/ak
export Ali_Key="$(jq -r '.AccessKeyId' $access_key_file)"
export Ali_Secret="$(jq -r '.AccessKeySecret' $access_key_file)"

~/Apps/acme/acme.sh --issue --server letsencrypt --home ~/Apps/acme \
  --dns dns_ali -d "$domain" -d "*.$domain"

cat ~/Apps/acme/account.conf
# SAVED_Ali_Key='xxxx'
# SAVED_Ali_Secret='xxxx'

#### 3. setup cron
# crontab -l; crontab -e
# 0 0 * * * /path/to/home/crons/acme_cron.sh YourDomain
