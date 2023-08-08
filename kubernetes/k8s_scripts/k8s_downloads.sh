#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

set -x

mkdir -p k8s_apps/images

#### 1. k8s_images
kubeadm config images list | xargs -i docker pull {}

for img in $(kubeadm config images list); do
    base=$(basename $img | sed 's/:/_/')
    docker save $img | pigz -c > k8s_apps/images/$base.tar.gz
done

#### 2. nerdctl
nerdctl_version=${nerdctl_version:-1.5.0}
nerdctl_out=nerdctl-full-${nerdctl_version}-linux-amd64.tar.gz

wget -O k8s_apps/$nerdctl_out \
  https://github.com/containerd/nerdctl/releases/download/v${nerdctl_version}/$nerdctl_out

#### 3. yq
yq_version=${yq_version:-4.34.2}

wget -O k8s_apps/yq_linux_amd64.tar.gz \
  https://github.com/mikefarah/yq/releases/download/v$yq_version/yq_linux_amd64.tar.gz

#### 4. ingress-nginx
wget -O k8s_apps/ingress-nginx_cloud.yaml \
  https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

sed -i '/image:/s/@sha256:.*//' k8s_apps/ingress-nginx_cloud.yaml
ingress_images=$(awk '/image:/{print $NF}' k8s_apps/ingress-nginx_cloud.yaml | sort -u)

for img in $ingress_images; do
     docker pull $img
     base=$(basename $img | sed 's/:/_/') 
     docker save $img | pigz -c > k8s_apps/images/$base.tar.gz
done

#### 5. calico and flannel
wget -O k8s_apps/calico.yaml https://docs.projectcalico.org/manifests/calico.yaml

wget -O k8s_apps/kube-flannel.yaml \
  https://raw.githubusercontent.com/flannel-io/flannel/v0.20.2/Documentation/kube-flannel.yml
