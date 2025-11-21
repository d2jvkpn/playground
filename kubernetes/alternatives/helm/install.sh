#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

sudo apt-get install curl gpg apt-transport-https --yes

curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey |
  gpg --dearmor |
  sudo tee /usr/share/keyrings/helm.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" |
  sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

sudo apt-get update
sudo apt-get install helm

exit
ansible all -m synchronize \
  -a "mode=push src=image_traefik_v3.2.2.tar.gz dest=./cache/k8s.downloads/images"

ansible all -m shell --become \
  -a "ctr -n=k8s.io image import ./cache/k8s.downloads/images/image_traefik_v3.2.2.tar.gz"

kubectl get pods --namespace kube-system -l app.kubernetes.io/name=traefik

helm template myrelease mychart --output-dir ./output

helm template myrelease mychart --output-dir ./output --values custom-values.yaml
