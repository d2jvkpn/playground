#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {} )

# minute hour day_of_month month day_of_week command
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
