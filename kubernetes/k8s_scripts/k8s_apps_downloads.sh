#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

yq_version=${yq_version:-4.35.1}
flannel_version=${flannel_version:-0.22.2}

set -x
mkdir -p k8s_apps/kube_images k8s_apps/ingress-nginx_images

function download_images() {
    yf=$1; save_dir=$2
    mkdir -p $save_dir

    images=$(awk '$1=="image:"{sub("@.*", "", $2); print $2}' $yf | sort -u)

    for img in $images; do
        base=$(basename $img | sed 's/:/_/')
        [ -f $save_dir/$base.tar.gz ] && continue

        docker pull $img
        docker save $img | pigz -c > $save_dir/$base.tar.gz.tmp
        mv $save_dir/$base.tar.gz.tmp $save_dir/$base.tar.gz
        docker rmi $img || true

        echo "==> Saved $save_dir/$base.tar.gz"
    done
}

#### 1. k8s_images
kubeadm config images list | xargs -i docker pull {}

kube_version=$(kubeadm version -o json | jq -r .clientVersion.gitVersion)
kubeadm config images list | sed 's/^/image: /' > k8s_apps/kube_$kube_version.txt

download_images k8s_apps/kube_$kube_version.txt k8s_apps/kube_images

#### 2. ingress-nginx and flannel
wget -O k8s_apps/ingress-nginx_cloud.yaml \
  https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

download_images k8s_apps/ingress-nginx_cloud.yaml k8s_apps/ingress-nginx_images


wget -O k8s_apps/kube-flannel.yaml \
  https://raw.githubusercontent.com/flannel-io/flannel/v$flannel_version/Documentation/kube-flannel.yml

download_images k8s_apps/kube-flannel.yaml k8s_apps/flannel_images


# wget -O k8s_apps/calico.yaml https://docs.projectcalico.org/manifests/calico.yaml
# download_images k8s_apps/calico.yaml k8s_apps/calico_images

#### 4. yq
wget -O k8s_apps/yq_linux_amd64.tar.gz \
  https://github.com/mikefarah/yq/releases/download/v$yq_version/yq_linux_amd64.tar.gz

exit
yq_dir=k8s_apps/yq-${yq_version}-linux-amd64
mkdir -p $yq_dir

tar -xf k8s_apps/yq_linux_amd64.tar.gz -C $yq_dir
tar -C k8s_apps -czf $yq_dir.tar.gz yq-${yq_version}-linux-amd64
rm -rf $yq_dir k8s_apps/yq_linux_amd64.tar.gz

#### 5. nerdctl
nerdctl_version=${nerdctl_version:-1.5.0}
nerdctl_tgz=nerdctl-full-${nerdctl_version}-linux-amd64.tar.gz

wget -O k8s_apps/$nerdctl_tgz \
  https://github.com/containerd/nerdctl/releases/download/v${nerdctl_version}/$nerdctl_tgz
