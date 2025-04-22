#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


now_ts=$(date +%s)

function tls_expiry() {
    namespace=$1; ingress=$2

    #secret_names=$(kubectl -n $namespace get ingress $ingress -o jsonpath="{.spec.tls[*].secretName}")
    tls=$(kubectl -n $namespace get ingress $ingress -o jsonpath="{.spec.tls[]}")

    secret_names=$(echo $tls | jq -r ".secretName")
    hosts=$(echo $tls | jq -r '.hosts | join(",")')

    for name in $secret_names; do
        tls_crt=$(kubectl -n $namespace get secret $name -o jsonpath="{.data.tls\.crt}")

        if [[ -z "$tls_crt" || "$tls_crt" == "null" ]]; then
            continue
        fi

        tls_crt=$(echo $tls_crt | base64 --decode)
        subject=$(echo "$tls_crt" | openssl x509 -noout -subject | sed 's/.* = //')

        expire_date=$(echo "$tls_crt" | openssl x509 -noout -enddate | cut -d= -f 2)
        expire_rfc3339=$(date -d "$expire_date" +"%Y-%m-%dT%H:%M:%S%:z")
        expire_ts=$(date -d "$expire_date" +"%s")
        expire_secs=$((expire_ts - now_ts))
        
        echo "$namespace $ingress $hosts $subject $expire_rfc3339 $expire_secs"
    done
}

namespace=$1

if [ $# -gt 1 ]; then
    shift
    ingress_list=$@
else
    ingress_list=$(kubectl -n $namespace get ingress | awk 'NR>1{print $1}')
fi

echo "namespace ingress hosts subject expire_rfc3339 expire_secs"
for ingress in $ingress_list; do
    tls_expiry $namespace $ingress
done
