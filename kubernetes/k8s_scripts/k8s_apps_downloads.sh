#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

yq_version=${yq_version:-4.34.2}
nerdctl_version=${nerdctl_version:-1.5.0}

set -x

mkdir -p k8s_apps/kube_images k8s_apps/ingress-nginx_images

#### 1. k8s_images
kubeadm config images list | xargs -i docker pull {}

kube_version=$(kubeadm version -o json | jq -r .clientVersion.gitVersion)
kubeadm config images list > k8s_apps/kube_$kube_version.txt

for img in $(cat k8s_apps/kube_$kube_version.txt); do
    base=$(basename $img | sed 's/:/_/')
    docker save $img | pigz -c > k8s_apps/kube_images/$base.tar.gz
    docker rmi $img
done

#### 2. ingress-nginx
wget -O k8s_apps/ingress-nginx_cloud.yaml \
  https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

ingress_images=$(
  awk '/image:/{sub("@.*", "", $NF); print $NF}' k8s_apps/ingress-nginx_cloud.yaml |
  sort -u
)

for img in $ingress_images; do
     docker pull $img
     base=$(basename $img | sed 's/:/_/') 
     docker save $img | pigz -c > k8s_apps/ingress-nginx_images/$base.tar.gz
     docker rmi $img
done

#### 3. calico and flannel
wget -O k8s_apps/calico.yaml https://docs.projectcalico.org/manifests/calico.yaml

wget -O k8s_apps/kube-flannel.yaml \
  https://raw.githubusercontent.com/flannel-io/flannel/v0.20.2/Documentation/kube-flannel.yml

#### 4. yq
yq_version=${yq_version:-4.34.2}
yq_dir=k8s_apps/yq-${yq_version}-linux-amd64

wget -O k8s_apps/yq_linux_amd64.tar.gz \
  https://github.com/mikefarah/yq/releases/download/v$yq_version/yq_linux_amd64.tar.gz

mkdir -p $yq_dir
tar -xf k8s_apps/yq_linux_amd64.tar.gz -C $yq_dir
mv $yq_dir/yq_linux_amd64 $yq_dir/yq

tar -C k8s_apps -czf $yq_dir.tar.gz yq-${yq_version}-linux-amd64
rm -rf $yq_dir k8s_apps/yq_linux_amd64.tar.gz

exit

#### 5. nerdctl
nerdctl_version=${nerdctl_version:-1.5.0}

nerdctl_tgz=nerdctl-full-${nerdctl_version}-linux-amd64.tar.gz

wget -O k8s_apps/$nerdctl_tgz\
  https://github.com/containerd/nerdctl/releases/download/v${nerdctl_version}/$nerdctl_tgz
