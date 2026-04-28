#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

# minute hour day_of_month month day_of_week command
# cron: 10 0 * * * bash ${HOME}/apps/crons/acme_cron.sh
# help: https://crontab.guru

acme_dir=${acme_dir:-~/apps/acme}
target_dir=${target_dir:-~/apps/nginx/certs}
changed="false";

{
    date +"==> %FT%T%:z run acme_cron.sh"
    $acme_dir/acme.sh --cron --server letsencrypt --home $acme_dir

    for certs_dir in $(ls -d $acme_dir/*_ecc/ | sed 's#/$##'); do
        domain=$(basename $certs_dir | sed 's/_ecc$//')

        s1=$(md5sum $certs_dir/fullchain.cer $certs_dir/$domain.key | awk '{print $1}')
        s2=""
        if [ -f $target_dir/$domain.cer ]; then
            s2=$(md5sum $target_dir/fullchain.cer $target_dir/$domain.key | awk '{print $1}')
        fi
        [[ "$s1" == "$s2" ]] && continue

        changed="true"
        date +"--> %FT%T%:z renew ${domain}"
        rsync ${certs_dir}/$domain.key $target_dir/
        rsync ${certs_dir}/fullchain.cer $target_dir/$domain.fullchain.cer
    done

    if [[ "$changed" == "true" ]]; then
        echo "--> reload nginx"
        sudo nginx -t
        sudo nginx -s reload
    else
        echo "--> no need to reload nginx"
    fi
} >> ${_path}/acme_cron.$(date +"%Y-%m").log 2>&1

exit

kubectl -n dev create secret tls $domain --dry-run=client \
  --key ${certs_dir}/$domain.key --cert ${certs_dir}/fullchain.cer -o yaml |
  kubectl apply -f -
