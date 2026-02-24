#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
python3 > pip_constraints.txt <<'EOF'
import os
import importlib.metadata as md

pkgs = ["torch", "torchaudio", "torchvision"]
pkgs.extend(os.sys.argv[1:])

for p in pkgs:
    try:
        print(f"{p}=={md.version(p)}")
    except md.PackageNotFoundError:
        pass
EOF

exit
pip freeze > pip_constraints.txt

exit
pip install --dry-run requirements.txt --upgrade-strategy only-if-needed -c pip_constraints.txt
pip install -v requirements.txt --upgrade-strategy only-if-needed -c pip_constraints.txt
