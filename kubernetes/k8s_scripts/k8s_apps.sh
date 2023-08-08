#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

set -x

mkdir -p /opt/bin

#### 1. k8s images
for f in $(ls k8s_apps/images/*.tar.gz); do
    pigz -dc $f | sudo ctr -n=k8s.io image import -
done

#### 2. nerdctl
nerdctl_version=${nerdctl_version:-1.5.0}
nerdctl_out=nerdctl-full-${nerdctl_version}-linux-amd64.tar.gz

mkdir -p k8s_apps/nerdctl /opt/cni/bin/ /opt/nerdctl
tar -xf k8s_apps/$nerdctl_out -C k8s_apps/nerdctl
cp k8s_apps/nerdctl/bin/* /opt/nerdctl/
cp k8s_apps/nerdctl/libexec/cni/* /opt/cni/bin/
rm -r k8s_apps/nerdctl

# nerdctl -n k8s.io images
# nerdctl ps -a
# nerdctl -n k8s.io ps -a

#### 3. yq
mkdir -p k8s_apps/yq
tar -xf k8s_apps/yq_linux_amd64.tar.gz -C k8s_apps/yq

chmod a+x k8s_apps/yq/yq_linux_amd64
mv k8s_apps/yq/yq_linux_amd64 /opt/bin/yq
rm -r k8s_apps/yq
