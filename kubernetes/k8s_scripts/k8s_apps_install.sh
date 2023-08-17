#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### 1. k8s images
for f in $(ls k8s_apps/*_images/*.tar.gz); do
    pigz -dc $f | sudo ctr -n=k8s.io image import -
done

#### 2. yq
mkdir -p k8s_apps/yq_linux_amd64
tar -xf k8s_apps/yq_linux_amd64.tar.gz -C k8s_apps/yq_linux_amd64
mv k8s_apps/yq_linux_amd64/yq /usr/bin/
rm -r k8s_apps/yq_linux_amd64

exit

#### 3. nerdctl
# sudo crictl images
tar -xf k8s_apps/nerdctl-*-linux-amd64.tar.gz -C /opts/
mv /opts/nerdctl-*-linux-amd64/libexec/cni /opt/

# nerdctl -n k8s.io images
# nerdctl ps -a
# nerdctl -n k8s.io ps -a
