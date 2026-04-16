#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


addr=$1
branch=${2:-""}
name=$(basename "$addr" .git)

pip_constraints=~/.local/venv/pip_constraints.txt

if [[ -z "$branch" ]]; then
    git clone --depth 1 --single-branch "$addr" custom_nodes/"$name"
else
    git clone --branch "$branch" --depth 1 --single-branch "$addr" custom_nodes/"$name"
fi

pip install --no-cache-dir --upgrade-strategy only-if-needed -c "$pip_constraints"
  -r "custom_nodes/$name/requirements.txt"

exit
for f in $(ls custom_nodes/*/requirements.txt | grep -v "\.disabled/"); do
    pip install --upgrade-strategy only-if-needed -c "$pip_constraints" -r "$f"
done

exit
pip install --upgrade-strategy only-if-needed -c ~/.local/venv/pip_constraints.txt \
  --dry-run requirements.txt

pip install --upgrade-strategy only-if-needed -c ~/.local/venv/pip_constraints.txt \
   -r requirements.txt
