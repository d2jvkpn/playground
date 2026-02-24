#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


addr=$1
branch=${2:-""}
name=$(basename "$addr" .git)

if [[ -z "$branch" ]]; then
    git clone --depth 1 --single-branch "$addr" custom_nodes/"$name"
else
    git clone --branch "$branch" --depth 1 --single-branch "$addr" custom_nodes/"$name"
fi

pip install --no-cache-dir \
  -r custom_nodes/"$name"/requirements.txt \
  --upgrade-strategy only-if-needed -c ~/venv/pip_constraints.txt

exit
for f in $(ls custom_nodes/*/requirements.txt | grep -v "\.disabled/"); do
    pip install -r $f --upgrade-strategy only-if-needed -c ~/venv/pip_constraints.txt
done

exit
pip install --dry-run requirements.txt --upgrade-strategy only-if-needed -c ~/venv/pip_constraints.txt

pip install -v requirements.txt --upgrade-strategy only-if-needed -c ~/venv/pip_constraints.txt
