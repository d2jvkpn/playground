#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


####
kubectl config current-context

kubectl config view --minify

####
kubect top nodes

kubect describe nodes

kubectl top pods -A
