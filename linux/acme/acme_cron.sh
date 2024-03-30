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
