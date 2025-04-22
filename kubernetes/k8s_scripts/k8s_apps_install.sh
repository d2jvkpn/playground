#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


#### 1. yq
if [ ! -f /usr/bin/yq ]; then
    # mkdir -p k8s.local/yq_dir
    # tar -xf k8s.local/yq_linux_amd64.tar.gz -C k8s.local/yq_dir
    # mv k8s.local/yq_dir/yq_linux_amd64 /usr/bin/yq
    # rm -r k8s.local/yq_dir

    chmod a+x k8s.local/yq
    mv k8s.local/yq /usr/bin/yq
fi

#### 2. k8s images
[ "${import_image:-unknown}" == "true" ] && \
for f in $(ls k8s.local/images/*.tar.gz); do
    pigz -dc $f | sudo ctr -n=k8s.io image import -
done

#### 3. nerdctl
# sudo crictl images
# tar -xf k8s.local/nerdctl-*-linux-amd64.tar.gz -C /opts/
# mv /opts/nerdctl-*-linux-amd64/libexec/cni /opt/

# nerdctl -n k8s.io images
# nerdctl ps -a
# nerdctl -n k8s.io ps -a
