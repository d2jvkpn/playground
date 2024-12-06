#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# echo "Hello, world!"

ls -lt ~/.kube

yaml_list=$(ls ~/.kube/*.yaml | tr '\n' ':' | sed 's/:$//')

KUBECONFIG=~/.kube/config: kubectl config view --merge --flatten > ~/.kube/temp

mv ~/.kube/temp ~/.kube/config

kubectl config get-contexts

kubectl config set-context --current --namespace=dev

exit
kubectl config set-context --cluster=cluster01

kubectl config current-context

kubectl config use-context ctx01

kubectl config get-clusters
