#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {} )

# cron: 0 0 * * * bash ${HOME}/crons/acme_cron.sh

acme=~/Apps/acme # directory
target_dir=${target_dir:-~/nginx/certs}
changed="false";

{
    date +"==> %FT%T%:z run acme_cron.sh"
    $acme/acme.sh --cron --server letsencrypt --home $acme

    for certs_dir in $(ls -d $acme/*_ecc/ | sed 's#/$##'); do
        domain=$(basename $certs_dir | sed 's/_ecc$//')

        s1=$(md5sum $certs_dir/$domain.cer | awk '{print $1}')
        s2=""
        [ -f $target_dir/$domain.cer ] && s2=$(md5sum $target_dir/$domain.cer | awk '{print $1}')
        [[ "$s1" == "$s2" ]] && continue

        changed="true"
        date +"--> %FT%T%:z renew ${domain}"
        rsync ${certs_dir}/$domain.{key,cer} $target_dir/
    done

    # sudo nginx -t
    [[ "$changed" == "true" ]] && sudo nginx -s reload
} >> ${_path}/acme_cron.$(date +"%Y-%m").log 2>&1

exit

kubectl -n dev create secret tls $domain --dry-run=client \
  --key ${certs_dir}/$domain.key --cert ${certs_dir}/$domain.cer -o yaml |
  kubectl apply -f -

exit

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
# 0 0 * * * /path/to/home/crons/acme_cron.sh
