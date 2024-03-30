#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

nerdctl_version=${nerdctl_version:-1.5.0}
nerdctl_tgz=nerdctl-full-${nerdctl_version}-linux-amd64.tar.gz

wget -O k8s_apps/$nerdctl_tgz \
  https://github.com/containerd/nerdctl/releases/download/v${nerdctl_version}/$nerdctl_tgz
