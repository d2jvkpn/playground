#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

# yq_version=${yq_version:-4.35.2}
# flannel_version=${flannel_version:-0.23.0}

# 1.34.2
version=$(
  kubeadm version --output json |
  jq -r .clientVersion.gitVersion |
  sed 's/^v//'
)

version=${1:-$version}
output_dir=cache/k8s.downloads

function download_images() {
    yf=$1; save_dir=$2
    mkdir -p $save_dir

    # images=$(awk '$1=="image:"{sub("@.*", "", $2); print $2}' $yf | sort -u)
    images=$(awk '/ image:/{sub("@.*", "", $NF); print $NF}' $yf | sort -u)

    for img in $images; do
        base=$(echo $img | sed 's#/#_#g; s#:#_#g')
        [ -f $save_dir/$base.tar.gz ] && continue

        docker pull $img
        docker save $img | pigz -c > $save_dir/$base.tar.gz.tmp
        mv $save_dir/$base.tar.gz.tmp $save_dir/$base.tar.gz
        docker rmi $img || true

        echo "==> Saved $save_dir/$base.tar.gz"
    done
}

{
    command -v kubeadm;
    command -v wget;
    command -v docker;
    command -v yq;
} > /dev/null

current=$(kubeadm version -o yaml | yq .clientVersion.gitVersion | sed 's/^v//')
# kube_version=$(kubeadm version -o json | jq -r .clientVersion.gitVersion | sed 's/^v//')
[ "$version" != "$current" ] && {
  >&2 echo '!!! '"unexpected version: $current";
  exit 1;
}

mkdir -p $output_dir/images


#### 1. k8s_images
# kubeadm config images list | xargs -i docker pull {}
k8s_images=$(kubeadm config images list)


#### 2. flannel
# https://raw.githubusercontent.com/flannel-io/flannel/v${flannel_version}/Documentation/kube-flannel.yml
link=https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
wget -O $output_dir/flannel.yaml $link
sed -i "1i # link: $link\n" $output_dir/flannel.yaml

flannel_images=$(awk '$1=="image:"{print $2}' $output_dir/flannel.yaml | sort -u)


#### 3. calico
link=https://docs.projectcalico.org/manifests/calico.yaml
wget -O $output_dir/calico.yaml $link
sed -i "1i # link: $link\n" $output_dir/calico.yaml

calico_images=$(awk '$1=="image:"{print $2}' $output_dir/calico.yaml | sort -u)


#### 4. metrics-server
link=https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
wget -O $output_dir/metrics-server_components.yaml $link
sed -i "1i # link: $link\n" $output_dir/metrics-server_components.yaml

metrics_images=$(
  awk '$1=="image:"{print $2}' $output_dir/metrics-server_components.yaml |
  sort -u
)


#### 5. metallb
for k in native frr frr-k8s; do
    wget -O $output_dir/metallb-${k}.yaml \
      https://raw.githubusercontent.com/metallb/metallb/refs/heads/main/config/manifests/metallb-${k}.yaml
done

metallb_images=$(awk '$1=="image:"{print $2}' $output_dir/metallb-*.yaml | sort -u)


#### 6. yq
# https://github.com/mikefarah/yq/releases/download/v${yq_version}/yq_linux_amd64.tar.gz
# https://github.com/mikefarah/yq/releases/download/v${yq_version}/yq_linux_amd64
wget -O $output_dir/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
chmod a+x $output_dir/yq
# yq_version=$(./$output_dir/yq --version | awk '{print $NF}')

#### 7. cilium
# --remote-name
curl -o /tmp/cilium-linux-amd64.tar.gz \
  -L https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz

tar -xf /tmp/cilium-linux-amd64.tar.gz -C $output_dir/

#### 8. download info
cat > $output_dir/k8s_downloads.yaml << EOF
k8s:
  version: $version
  images:
$(echo "$k8s_images" | sed 's/^/  - image: /')

flannel:
  images:
$(echo "$flannel_images" | sed 's/^/  - image: /')

metrics-server:
  images:
$(echo "$metrics_images" | sed 's/^/  - image: /')

metallb-server:
  images:
$(echo "$metallb_images" | sed 's/^/  - image: /')
EOF

download_images $output_dir/k8s_downloads.yaml $output_dir/images
