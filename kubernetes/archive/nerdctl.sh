#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

nerdctl_version=${nerdctl_version:-1.5.0}
nerdctl_tgz=nerdctl-full-${nerdctl_version}-linux-amd64.tar.gz

wget -O k8s.local/$nerdctl_tgz \
  https://github.com/containerd/nerdctl/releases/download/v${nerdctl_version}/$nerdctl_tgz
