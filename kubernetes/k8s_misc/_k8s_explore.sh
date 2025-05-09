#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


# echo "Hello, world!"

kubectl get ingress -A | awk '{print $1, $2, $4}' | column -t

kubectl get services,deployments,ingress -A

kubectl get ingress -A

kubectl get ns |
  awk 'NR>1{print $1}' |
  xargs -i kubectl -n {} get ingress --no-headers 2>/dev/null |
  awk '{print $1, $4, $3}' |
  column -t

kubectl get ns |
  awk 'NR>1{print $1}' |
  xargs -i kubectl -n {} get services --no-headers 2>/dev/null |
  awk '$2=="LoadBalancer"{print}' |
  column -t
