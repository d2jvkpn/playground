#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0) # set -x


# 1. install helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# 2. add traefik
helm repo add traefik https://traefik.github.io/charts
helm repo update

# 3. install traefik
helm install traefik traefik/traefik --namespace kube-system

# 4.
kubectl get pods --namespace kube-system -l app.kubernetes.io/name=traefik

kubectl port-forward \
  $(kubectl get pods --namespace kube-system -l "app.kubernetes.io/name=traefik" -o jsonpath="{.items[0].metadata.name}") \
  9000:9000 --namespace kube-system

cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  namespace: default
  annotations:
    traefik.ingress.kubernetes.io/router.entrypoints: web
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: example-service
            port:
              number: 80
EOF
