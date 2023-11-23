#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

# https://kubernetes.github.io/ingress-nginx/user-guide/exposing-tcp-udp-services/*

namespace=${namespace:-dev}
srv=$1; port=$2

####
found=$(
  kubectl -n ingress-nginx get deploy/ingress-nginx-controller -o yaml |
    yq eval '.spec.template.spec.containers[0].args' |
    grep "\-\-tcp-services-configmap" || true
)

elem='"--tcp-services-configmap=$(POD_NAMESPACE)/tcp-services"'
# elem='"--udp-services-configmap=$(POD_NAMESPACE)/udp-services"'

if [ -z "$found" ]; then
    kubectl -n ingress-nginx get deploy/ingress-nginx-controller -o yaml |
      yq eval '.spec.template.spec.containers[0].args += ['$elem']' > ingress.temp.yaml

    kubectl apply -f ingress.temp.yaml
    rm -f ingress.temp.yaml
fi

####
found=$(
  kubectl -n ingress-nginx get services/ingress-nginx-controller -o yaml |
    yq eval .spec.ports |
    grep -w $port || true
)

elem='{"name":"'$srv'","protocol":"TCP","port":'$port',"targetPort":'$port'}'

if [ -z "$found" ]; then
    kubectl -n ingress-nginx get services/ingress-nginx-controller -o yaml |
      yq eval '.spec.ports += ['$elem']' > ingress.temp.yaml

    kubectl apply -f ingress.temp.yaml
    rm -f ingress.temp.yaml
fi

# kubectl -n ingress-nginx get services/ingress-nginx-controller

####
found=$(kubectl -n ingress-nginx get cm/tcp-services || true)

if [ -z "$found" ]; then
cat > tcp-services.temp.yaml <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: ingress-nginx
  name: tcp-services
data:
  "$port": $namespace/$srv:$port
EOF
    kubectl apply -f tcp-services.temp.yaml
    rm -f tcp-services.temp.yaml
fi

# kubectl -n ingress-nginx get cm/tcp-services -o yaml |
#   yq eval '.data += {"'$port'":"'$namespace/$srv:$port'"}'
#   kubectl apply -f -

####
{
    kubectl -n ingress-nginx get deploy/ingress-nginx-controller -o yaml | yq 'del .status'
    echo "---"

    kubectl -n ingress-nginx get svc/ingress-nginx-controller -o yaml | yq 'del .status'
    echo "---"

    kubectl -n ingress-nginx get cm/tcp-services -o yaml
} > k8s_apps/data/ingress-nginx.patch.yaml

exit

postgres_port=$(
  kubectl -n ingress-nginx get services/ingress-nginx-controller -o yaml |
    yq eval .spec.ports |
    grep -w 5432 || true
)

[ -z "$postgres_port" ] &&
kubectl -n ingress-nginx get services/ingress-nginx-controller -o yaml |
  yq eval '.spec.ports += [{"name":"postgres","protocol":"TCP","port":5432,"targetPort":5432}]' |
  kubectl apply -f -

# psql --host k8s.local --username postgres --port 5432
