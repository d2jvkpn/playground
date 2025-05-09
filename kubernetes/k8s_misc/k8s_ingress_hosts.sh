#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


# kubectl -n $namespace get ingress $name -o custom-columns=ADRESS:spec.tls[*].hosts[*]

# kubectl get ingress -A -o custom-columns=metadata.namespace,ADRESS:spec.tls[*].hosts[*]

# kubectl get ingress -A -o jsonpath='{range .items[*]}{.metadata.namespace}{"\t"}{range .spec.rules[*]}{.host}{"\n"}{end}{end}'

output=ingress_hosts.$(date +%Y%m%d-%s).tsv

kubectl get ingress --all-namespaces -o json |
  jq -r '.items[] | "\(.metadata.namespace)\t\(.spec.rules | map(.host) | join(","))"' |
  sed '1i namespace\thosts' > $output

exit
awk 'NR>1{print $2}' $output | tr ',' '\n' | sort -u
