#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### 1. k8s images
for f in $(ls k8s_apps/*_images/*.tar.gz); do
    pigz -dc $f | sudo ctr -n=k8s.io image import -
done

#### 2. yq
tar -xf k8s_apps/yq-*-linux-amd64.tar.gz -C /opt/

exit

#### 3. nerdctl
# sudo crictl images

mkdir -p k8s_apps/nerdctl /opt/cni/bin/ /opt/nerdctl

tar -xf k8s_apps/nerdctl-linux-amd64.tar.gz -C /opts/
cp k8s_apps/nerdctl/bin/* /opt/nerdctl/
cp k8s_apps/nerdctl/libexec/cni/* /opt/cni/bin/
rm -r k8s_apps/nerdctl

# nerdctl -n k8s.io images
# nerdctl ps -a
# nerdctl -n k8s.io ps -a
