#!/bin/bash

REPO_DIR="$1"

cd $REPO_DIR

COMMIT_HASH=$(git rev-parse HEAD)
COMMIT_DATE=$(git show -s --format=%ci HEAD)
AUTHOR_NAME=$(git show -s --format=%an HEAD)
AUTHOR_EMAIL=$(git show -s --format=%ae HEAD)

BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
BUILD_MACHINE=$(uname -n)

mkdir -p target

cat <<EOL > "target/build.txt"
Commit Hash: $COMMIT_HASH
Commit Date: $COMMIT_DATE
Author Name: $AUTHOR_NAME
Author Email: $AUTHOR_EMAIL
Build Date: $BUILD_DATE
Build Machine: $BUILD_MACHINE
EOL

