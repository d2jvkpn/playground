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

    # images=$(awk '$1=="image:"{sub("@.*", "", $2); print $2}' $yf | sort -u)
    images=$(awk '/ image:/{sub("@.*", "", $NF); print $NF}' $yf | sort -u)

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
kube_version=$(kubeadm version -o json | jq -r .clientVersion.gitVersion | sed 's/^v//')

#### 2. ingress-nginx and flannel
wget -O k8s_apps/ingress-nginx_cloud.yaml \
  https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

ingress_images=$(
  awk '$1=="image:"{print $2}' k8s_apps/ingress-nginx_cloud.yaml |
  sort -u
)

wget -O k8s_apps/kube-flannel.yaml \
  https://raw.githubusercontent.com/flannel-io/flannel/v$flannel_version/Documentation/kube-flannel.yml

flannel_images=$(awk '$1=="image:"{print $2}' k8s_apps/kube-flannel.yaml | sort -u)

# wget -O k8s_apps/calico.yaml https://docs.projectcalico.org/manifests/calico.yaml

#### 3. yq
wget -O k8s_apps/yq_linux_amd64.tar.gz \
  https://github.com/mikefarah/yq/releases/download/v$yq_version/yq_linux_amd64.tar.gz

#### 4. yaml info
cat > k8s_apps/k8s.yaml << EOF
version: $kube_version
images:
$(kubeadm config images list | sed 's/^/- image: /')

yq:
  version: $yq_version

ingress:
  images:
$(echo "$ingress_images" | sed 's/^/- image: /')

flannel:
  version: $flannel_version
  images:
$(echo "$flannel_images" | sed 's/^/  - image: /')
EOF

download_images k8s_apps/k8s.yaml k8s_apps/images

exit

#### 5. nerdctl
nerdctl_version=${nerdctl_version:-1.5.0}
nerdctl_tgz=nerdctl-full-${nerdctl_version}-linux-amd64.tar.gz

wget -O k8s_apps/$nerdctl_tgz \
  https://github.com/containerd/nerdctl/releases/download/v${nerdctl_version}/$nerdctl_tgz
