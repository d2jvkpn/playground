#!/usr/bin/env bash

set -Eeuo pipefail

log() {
    printf '\n==> %s\n' "$*"
}

fail() {
    printf '\nERROR: %s\n' "$*" >&2
    exit 1
}

command -v git >/dev/null 2>&1 || fail "git is not installed"
command -v go >/dev/null 2>&1 || fail "go is not installed"

git rev-parse --is-inside-work-tree >/dev/null 2>&1 ||
    fail "current directory is not inside a Git repository"

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

mapfile -t changed_go_files < <(
    {
        git diff --name-only --diff-filter=ACMR -- '*.go'
        git diff --cached --name-only --diff-filter=ACMR -- '*.go'
        git ls-files --others --exclude-standard -- '*.go'
    } | sort -u
)

if ((${#changed_go_files[@]} > 0)); then
    log "Checking formatting of changed Go files"

    unformatted="$(gofmt -l "${changed_go_files[@]}")"

    if [[ -n "$unformatted" ]]; then
        printf '%s\n' "$unformatted"
        fail "changed Go files are not formatted; run gofmt on the files above"
    fi
else
    log "No changed Go files found"
fi

log "Running Go tests"
go test ./...

log "Running go vet"
go vet ./...

if command -v staticcheck >/dev/null 2>&1; then
    log "Running staticcheck"
    staticcheck ./...
else
    log "staticcheck is not installed; skipping"
fi

log "Verification completed successfully"
