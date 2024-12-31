#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0) # set -x

####
kubectl config current-context

kubectl config view --minify

####
kubect top nodes

kubect describe nodes

kubectl top pods -A
