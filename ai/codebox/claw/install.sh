#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


mkdir -p data
git clone https://github.com/ultraworkers/claw-code data/ultraworkers--claw-code.git

cd data/ultraworkers--claw-code.git
cd rust

cargo build --workspace --release
ls -l target/release/ | awk '/^-rwxrwxr-x/'


exit
# ANTHROPIC_AUTH_TOKEN
export ANTHROPIC_API_KEY=xxxxxxxx ANTHROPIC_BASE_URL=https://example.com
