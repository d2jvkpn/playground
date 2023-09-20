#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# https://kubernetes.github.io/ingress-nginx/user-guide/exposing-tcp-udp-services/*

kubectl -n ingress-nginx get deploy/ingress-nginx-controller -o yaml |
  yq eval '.spec.template.spec.containers[0].args'

tcp_svc_cm=$(
  kubectl -n ingress-nginx get deploy/ingress-nginx-controller -o yaml |
    yq eval '.spec.template.spec.containers[0].args' |
    grep "\-\-tcp-services-configmap"
)

[ -z "$tcp_svc_cm" ] &&
kubectl -n ingress-nginx get deploy/ingress-nginx-controller -o yaml |
  yq eval '.spec.template.spec.containers[0].args +=
    ["--tcp-services-configmap=$(POD_NAMESPACE)/tcp-services"]' |
  kubectl apply -f -

# kubectl -n ingress-nginx get deploy/ingress-nginx-controller -o yaml |
#   yq eval '.spec.template.spec.containers[0].args += ["--udp-services-configmap=$(POD_NAMESPACE)/udp-services"]' |
#   kubectl apply -f -

postgres_port=$(
  kubectl -n ingress-nginx get services/ingress-nginx-controller -o yaml |
    yq eval .spec.ports |
    grep -w 5432
)

[ -z "$postgres_port" ] && 
kubectl -n ingress-nginx get services/ingress-nginx-controller -o yaml |
  yq eval '.spec.ports += [{"name":"postgres","protocol":"TCP","port":5432,"targetPort":5432}]' |
  kubectl apply -f -

mysql_port=$(
  kubectl -n ingress-nginx get services/ingress-nginx-controller -o yaml |
    yq eval .spec.ports |
    grep -w 3306
)

[ -z "$mysql_port" ] &&
kubectl -n ingress-nginx get services/ingress-nginx-controller -o yaml |
  yq eval '.spec.ports += [{"name":"mysql","protocol":"TCP","port":3306,"targetPort":3306}]' |
  kubectl apply -f -

kubectl -n ingress-nginx get services/ingress-nginx-controller

cat | kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: ingress-nginx
  name: tcp-services
data:
  "5432": dev/postgres:5432
  "3306": dev/mysql:3306
EOF

kubectl -n ingress-nginx get cm/tcp-services -o yaml

# psql --host k8s.local --username postgres --port 5432
