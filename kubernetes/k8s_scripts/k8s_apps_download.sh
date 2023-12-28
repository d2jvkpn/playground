#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

# yq_version=${yq_version:-4.35.2}
# flannel_version=${flannel_version:-0.23.0}

# 1.29.0
version=$1

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

{ command -v kubeadm; command -v wget; command -v docker; command -v yq; } > /dev/null

current=$(kubeadm version -o yaml | yq .clientVersion.gitVersion | sed 's/^v//')
# kube_version=$(kubeadm version -o json | jq -r .clientVersion.gitVersion | sed 's/^v//')
[ "$version" != "$current" ] && { >&2 echo '!!! '"unexpected version: $current"; exit 1; }

mkdir -p k8s_apps/images

#### 1. k8s_images
# kubeadm config images list | xargs -i docker pull {}
k8s_images=$(kubeadm config images list)

#### 2. ingress-nginx and flannel
link=https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
wget -O k8s_apps/ingress-nginx.yaml $link
sed -i "1i # link: $link\n" k8s_apps/ingress-nginx.yaml

ingress_images=$(awk '$1=="image:"{print $2}' k8s_apps/ingress-nginx.yaml | sort -u)

# https://raw.githubusercontent.com/flannel-io/flannel/v${flannel_version}/Documentation/kube-flannel.yml
link=https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
wget -O k8s_apps/flannel.yaml $link
sed -i "1i # link: $link\n" k8s_apps/flannel.yaml

flannel_images=$(awk '$1=="image:"{print $2}' k8s_apps/flannel.yaml | sort -u)

#### 3. calico
link=https://docs.projectcalico.org/manifests/calico.yaml
wget -O k8s_apps/calico.yaml $link
sed -i "1i # link: $link\n" k8s_apps/calico.yaml

calico_images=$(awk '$1=="image:"{print $2}' k8s_apps/calico.yaml | sort -u)

#### 4. metrics-server
link=https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
wget -O k8s_apps/metrics-server_components.yaml $link
sed -i "1i # link: $link\n" k8s_apps/metrics-server_components.yaml

metrics_images=$(awk '$1=="image:"{print $2}' k8s_apps/metrics-server_components.yaml | sort -u)

#### 4. yq
# https://github.com/mikefarah/yq/releases/download/v${yq_version}/yq_linux_amd64.tar.gz
# https://github.com/mikefarah/yq/releases/download/v${yq_version}/yq_linux_amd64
wget -O k8s_apps/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64

#### 5. yaml info
cat > k8s_apps/k8s.yaml << EOF
version: $version
images:
$(echo "$k8s_images" | sed 's/^/- image: /')

ingress:
  images:
$(echo "$ingress_images" | sed 's/^/  - image: /')

flannel:
  images:
$(echo "$flannel_images" | sed 's/^/  - image: /')

metrics-server:
  images:
$(echo "$metrics_images" | sed 's/^/  - image: /')
EOF

download_images k8s_apps/k8s.yaml k8s_apps/images
