#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


#### 1. yq
if [ ! -s /usr/bin/yq ]; then
    # mkdir -p cache/k8s.downloads/yq_dir
    # tar -xf cache/k8s.downloads/yq_linux_amd64.tar.gz -C cache/k8s.downloads/yq_dir
    # mv cache/k8s.downloads/yq_dir/yq_linux_amd64 /usr/bin/yq
    # rm -r cache/k8s.downloads/yq_dir

    chmod a+x cache/k8s.downloads/yq
    mv cache/k8s.downloads/yq /usr/bin/yq
fi

#### 2. k8s images
[ "${import_image:-unknown}" == "true" ] && \
for f in $(ls cache/k8s.downloads/images/*.tar.gz); do
    pigz -dc $f | sudo ctr -n=k8s.io image import -
done

#### 3. nerdctl
# sudo crictl images
# tar -xf cache/k8s.downloads/nerdctl-*-linux-amd64.tar.gz -C /opts/
# mv /opts/nerdctl-*-linux-amd64/libexec/cni /opt/

# nerdctl -n k8s.io images
# nerdctl ps -a
# nerdctl -n k8s.io ps -a
