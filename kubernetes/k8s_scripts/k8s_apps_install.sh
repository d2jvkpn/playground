#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

#### 1. yq
if [ ! -f /usr/bin/yq ]; then
    # mkdir -p k8s_apps/yq_dir
    # tar -xf k8s_apps/yq_linux_amd64.tar.gz -C k8s_apps/yq_dir
    # mv k8s_apps/yq_dir/yq_linux_amd64 /usr/bin/yq
    # rm -r k8s_apps/yq_dir

    chmod a+x k8s_apps/yq
    mv k8s_apps/yq /usr/bin/yq
fi

#### 2. k8s images
[ "${import_image:-unknown}" == "true" ] && \
for f in $(ls k8s_apps/images/*.tar.gz); do
    pigz -dc $f | sudo ctr -n=k8s.io image import -
done

#### 3. apt
apt clean && apt autoclean
apt remove && apt autoremove
dpkg -l | awk '/^rc/{print $2}' | xargs -i dpkg -P {}

#### 4. nerdctl
# sudo crictl images
# tar -xf k8s_apps/nerdctl-*-linux-amd64.tar.gz -C /opts/
# mv /opts/nerdctl-*-linux-amd64/libexec/cni /opt/

# nerdctl -n k8s.io images
# nerdctl ps -a
# nerdctl -n k8s.io ps -a
