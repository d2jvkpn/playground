#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)


cd /home/appuser/apps

wget https://download.blender.org/release/Blender5.2/blender-5.2.1-linux-x64.tar.xz

tar -xf blender-5.2.1-linux-x64.tar.xz

ln -sfn \
  /home/appuser/apps/blender-5.2.1-linux-x64/blender \
  /home/appuser/apps/bin/blender
