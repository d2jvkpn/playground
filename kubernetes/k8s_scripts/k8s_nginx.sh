#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

output_dir=cache/k8s.downloads

for k in baremetal cloud; do
    link=https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/$k/deploy.yaml

    wget -O $output_dir/ingress-nginx.$k.yaml $link
done

# sed -i "1i # link: $link\n" $output_dir/ingress-nginx.yaml

ingress_images=$(
  awk '$1=="image:"{print $2}' $output_dir/ingress-nginx.*.yaml |
  sort -u
)
