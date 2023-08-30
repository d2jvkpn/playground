#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {} )

# cron: 0 0 * * *
# location: ${HOME}/.acme.sh/${Host}

domain=$1

acme_home=$HOME/.acme.sh # directory
save_dir=$acme_home/$domain
cert_dir=$HOME/nginx/cert

{
    date +">>> %FT%T%:z run acme.sh"
    s1=$(md5sum $save_dir/$domain.cer | awk '{print $1}')

    ${acme_home}/acme.sh --cron --home $acme_home --server letsencrypt
    s2=$(md5sum $save_dir/$domain.cer | awk '{print $1}')

    if [[ "$s1" != "$s2" ]]; then
        date +"    %FT%T%:z renew ssl and reload nginx"
        rsync ${save_dir}/$domain.{key,cer} $cert_dir/
        sudo nginx -t reload
        sudo nginx -s reload
    fi
} >> ${_path}/acme.$(date +"%Y").log 2>&1
