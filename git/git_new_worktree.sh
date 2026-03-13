#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

# ============================
# Config
# ============================
BASE_DIR="${BASE_DIR:-$HOME/workspace/worktrees}"

# ============================
# Safety checks
# ============================

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "❌ Not inside a git repository."
    exit 1
fi

# Current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ "$CURRENT_BRANCH" = "HEAD" ]; then
    echo "❌ Detached HEAD. Checkout a branch first."
    exit 1
fi

# Task name as the first parameter
if [ -z "$1" ]; then
    echo "Usage: $0 <task-name>"
    exit 1
fi

TASK_NAME="$1"

# New branch
#NEW_BRANCH="${CURRENT_BRANCH}-${TASK_NAME}"
SAFE_TASK=$(printf '%s' "$TASK_NAME" | tr ' ' '-' | tr -cd 'A-Za-z0-9._-')
NEW_BRANCH="${CURRENT_BRANCH}-${SAFE_TASK}"
PROJECT_NAME=$(basename $PWD .git) # basename $PWD .git
WORKTREE_PATH="$BASE_DIR/${PROJECT_NAME}--$NEW_BRANCH"

if [ -e "$WORKTREE_PATH" ]; then
    echo "❌ Worktree directory already exists:"
    echo "   $WORKTREE_PATH"
    exit 1
fi

mkdir -p "$BASE_DIR"
# Check if the new branch exists
#if git show-ref --verify --quiet "refs/heads/$NEW_BRANCH"; then
#    echo "⚠️  Branch exists. Creating worktree from existing branch..."
#    git worktree add "$WORKTREE_PATH" "$NEW_BRANCH"
#else
    echo "🚀 Creating new branch and worktree..."
    git worktree add -b "$NEW_BRANCH" "$WORKTREE_PATH"
#fi

echo ""
echo "✅ Worktree created:"
echo "   Branch : $NEW_BRANCH"
echo "   Path   : $WORKTREE_PATH"
echo ""
echo "👉 cd $WORKTREE_PATH"
