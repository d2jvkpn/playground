#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

version=$1 # 6.8.0-51
ver=$(echo $version  | awk -F "." '{print $1"."$2}')

echo "==> remove kernel: version=${version}, ver=$ver"

set -x

sudo apt -y remove \
  linux-headers-${version}-generic \
  linux-hwe-${ver}-headers-${version} \
  linux-hwe-${ver}-tools-${version} \
  linux-image-${version}-generic \
  linux-modules-${version}-generic \
  linux-modules-extra-${version}-generic \
  linux-tools-${version}-generic

sudo dpkg -P \
  linux-image-${version}-generic \
  linux-modules-${version}-generic \
  linux-modules-extra-${version}-generic

exit

linux-headers-6.8.0-51-generic
linux-hwe-6.8-headers-6.8.0-51
linux-hwe-6.8-tools-6.8.0-51
linux-image-6.8.0-51-generic
linux-modules-6.8.0-51-generic
linux-modules-extra-6.8.0-51-generic
linux-tools-6.8.0-51-generic
