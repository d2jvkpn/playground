#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


ls -lt ~/.kube

yaml_list=$(ls ~/.kube/*.yaml | tr '\n' ':' | sed 's/:$//')

KUBECONFIG=~/.kube/config: kubectl config view --merge --flatten > ~/.kube/temp

mv ~/.kube/temp ~/.kube/config

kubectl config get-contexts

kubectl config set-context --current --namespace=dev

exit
kubectl config set-context --cluster=cluster01

kubectl config use-context ctx01

kubectl config current-context

kubectl config get-clusters
