#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

#### 1. 
function usage() {
    echo "Usage: $0 [-b branch] <git-url>"
    echo "Examples:"
    echo "  $0 https://github.com/user/repo"
    echo "  $0 https://github.com/user/repo/tree/master"
    echo "  $0 -b dev https://github.com/user/repo/tree/master   # -b overrides tree branch"
    exit 1
}

url="${1%/}"
url=$(printf '%s' "$url" | sed -E 's#/tree/[^/]+$##')
branch=""

while getopts ":b:" opt; do
    case $opt in
    b)
        branch="$OPTARG";;
    *)
        usage;;
    esac
done
shift $((OPTIND -1))

if [ $# -lt 1 ]; then
  usage
fi

#### 2. 
no_proto="${url#http://}"
no_proto="${no_proto#https://}"
repo_path="${no_proto#*/}"

#repo_name=$(basename "$url" .git)
repo_name=$(echo $repo_path | sed 's#/#--#g')

#### 3. 
echo "Cloning $url: $branch..."
if [ "${branch:-}" = "ALL" ]; then
    git clone --no-single-branch "$url" $repo_name.git
elif [ -n "${branch:-}" ]; then
    git clone -b "$branch" "$url" $repo_name.git
else
    git clone "$url" $repo_name.git
fi

zip -r $repo_name.git.zip.temp $repo_name.git
rm -rf $repo_name.git
mv $repo_name.git.zip.temp $repo_name.git.zip

echo "Done: $repo_name.git.zip"
