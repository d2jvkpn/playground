#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


# https://github.com/SagerNet/sing-box/releases
repo=SagerNet/sing-box
tag_name=$(curl -fsSL https://api.github.com/repos/$repo/releases/latest | jq -r .tag_name)

filename=sing-box-${tag_name#v}-linux-amd64.tar.gz

curl -fL https://github.com/$repo/releases/download/$tag_name/$filename -o $filename

exit
tar -xf $filename -C /opt/
ln -s /opt/${filename%.tar.gz}/sing-box /usr/local/bin/

exit
mkdir -p data
git clone --branch main https://github.com/SagerNet/sing-box data/SagerNet--sing-box.git
