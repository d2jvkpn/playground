#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit

#### disable FETCH ComfyRegistry Data: 5/113
mv custom_nodes/ComfyUI-Manager custom_nodes/ComfyUI-Manager.disabled
