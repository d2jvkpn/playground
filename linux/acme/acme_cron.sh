#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {} )

# cron: 0 0 * * * bash ${HOME}/crons/acme_cron.sh YourDomain

domain=$1

acme_home=~/crons/acme.sh # directory
certs_dir=$acme_home/${domain}_ecc
target_dir=$HOME/nginx/certs

{
    date +">>> %FT%T%:z run acme_cron.sh"
    s1=$(md5sum $certs_dir/$domain.cer | awk '{print $1}')

    ${acme_home}/acme.sh --cron --home $acme_home --server letsencrypt

    if [ -f $target_dir/$domain.cer ]; then
        s2=$(md5sum $target_dir/$domain.cer | awk '{print $1}')
    else
        s2=""
    fi

    if [[ "$s1" != "$s2" ]]; then
        date +"    %FT%T%:z renew ssl and reload nginx"
        rsync ${certs_dir}/$domain.{key,cer} $target_dir/
        sudo nginx -t
        sudo nginx -s reload
    fi
} >> ${_path}/acme_sh.$(date +"%Y-%m").log 2>&1

exit

#### 1. installation
git clone https://github.com/acmesh-official/acme.sh .acme.sh

# mkdir -p ~/Apps
# git clone https://github.com/acmesh-official/acme.sh ~/Apps/acme

# curl https://get.acme.sh | sh

mkdir -p ~/crons
cp acme_cron.sh ~/crons

~/.acme.sh/acme.sh --register-account -m $email

#### 2. setup account

##### 2.1 dns aliyun
# aliyun_account01_permissions=["AliyunDNSFullAccess"]
access_key_file=aliyun_account01.json
email=john@doe.local
domain=doe.local

# get access key https://ram.console.aliyun.com/manage/ak
export Ali_Key="$(jq -r '.AccessKeyId' $access_key_file)"
export Ali_Secret="$(jq -r '.AccessKeySecret' $access_key_file)"
~/.acme.sh/acme.sh --issue --dns dns_ali --server letsencrypt -d $domain -d *.$domain

cat ~/.acme.sh/account.conf
# SAVED_Ali_Key='xxxx'
# SAVED_Ali_Secret='xxxx'

#### 3. setup cron
# crontab -e # comment out default and add following line
# 0 0 * * * /path-to-your-home/crons/acme_cron.sh YourDomain
