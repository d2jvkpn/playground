#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# https://kubernetes.github.io/ingress-nginx/user-guide/exposing-tcp-udp-services/*

namespace=${namespace:-dev}
srv=$1; port=$2

####
found=$(
  kubectl -n ingress-nginx get deploy/ingress-nginx-controller -o yaml |
    yq eval '.spec.template.spec.containers[0].args' |
    grep "\-\-tcp-services-configmap"
)

elem='"--tcp-services-configmap=$(POD_NAMESPACE)/tcp-services"'

[ -z "$found" ] &&
kubectl -n ingress-nginx get deploy/ingress-nginx-controller -o yaml |
  yq eval '.spec.template.spec.containers[0].args += ['$elem']' |
  kubectl apply -f -

kubectl -n ingress-nginx get deploy/ingress-nginx-controller -o yaml |
  yq 'del .status' > k8s_apps/data/ingress-nginx.deploy_controller.yaml

####
# kubectl -n ingress-nginx get deploy/ingress-nginx-controller -o yaml |
#   yq eval '.spec.template.spec.containers[0].args += ["--udp-services-configmap=$(POD_NAMESPACE)/udp-services"]' |
#   kubectl apply -f -

####
found=$(
  kubectl -n ingress-nginx get services/ingress-nginx-controller -o yaml |
    yq eval .spec.ports |
    grep -w $port
)

elem='{"name":"'$srv'","protocol":"TCP","port":'$port',"targetPort":'$port'}'

[ -z "$found" ] &&
kubectl -n ingress-nginx get services/ingress-nginx-controller -o yaml |
  yq eval '.spec.ports += ['$elem']' |
  kubectl apply -f -

kubectl -n ingress-nginx get svc/ingress-nginx-controller -o yaml |
  yq 'del .status' > k8s_apps/data/ingress-nginx.svc_controller.yaml

# kubectl -n ingress-nginx get services/ingress-nginx-controller

####
found=$(kubectl -n ingress-nginx get cm/tcp-services || true)

[ -z "$found" ] &&
cat | kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: ingress-nginx
  name: tcp-services
data:
#  "5432": dev/postgres:5432
EOF

kubectl -n ingress-nginx get cm/tcp-services -o yaml |
  yq eval '.data += {"'$port'":"'$namespace/$srv:$port'"}' |
  kubectl apply -f -

kubectl -n ingress-nginx get cm/tcp-services -o yaml

kubectl -n ingress-nginx get cm/tcp-services -o yaml |
  yq 'del .metadata' > k8s_apps/data/ingress-nginx.cm_tcp-services.yaml

exit

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

# psql --host k8s.local --username postgres --port 5432
