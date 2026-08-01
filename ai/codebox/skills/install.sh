#!/usr/bin/env bash

set -Eeuo pipefail

usage() {
    cat <<'EOF'
Usage:
  ./install.sh [PROJECT_DIR] [--force]

Examples:
  ./install.sh
  ./install.sh /path/to/repository
  ./install.sh /path/to/repository --force

The installer configures a project-level manual-only skill for:
  - Claude Code
  - OpenAI Codex
  - Pi Coding Agent
  - OpenCode

Existing opencode.json/opencode.jsonc and .pi/settings.json files are not
overwritten. Merge the matching files from config-snippets/ when needed.
EOF
}

force=false
target_dir=""

for arg in "$@"; do
    case "$arg" in
        --force)
            force=true
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            if [[ -n "$target_dir" ]]; then
                printf 'Unexpected argument: %s\n' "$arg" >&2
                usage >&2
                exit 2
            fi
            target_dir="$arg"
            ;;
    esac
done

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ -z "$target_dir" ]]; then
    target_dir="$PWD"
fi

target_dir="$(cd -- "$target_dir" && pwd)"

source_skill="$script_dir/go-change-review"
agents_target="$target_dir/.agents/skills/go-change-review"
claude_root="$target_dir/.claude/skills"
claude_target="$claude_root/go-change-review"

if [[ ! -f "$source_skill/SKILL.md" ]]; then
    printf 'Missing source skill: %s\n' "$source_skill/SKILL.md" >&2
    exit 1
fi

mkdir -p "$(dirname -- "$agents_target")" "$claude_root"

if [[ -e "$agents_target" || -L "$agents_target" ]]; then
    if ! $force; then
        printf 'Skill already exists: %s\n' "$agents_target" >&2
        printf 'Use --force to replace this example installation.\n' >&2
        exit 1
    fi
    rm -rf -- "$agents_target"
fi

cp -R -- "$source_skill" "$agents_target"
chmod +x "$agents_target/scripts/verify.sh"
printf 'Installed shared skill: %s\n' "$agents_target"

if [[ -e "$claude_target" || -L "$claude_target" ]]; then
    if $force; then
        rm -rf -- "$claude_target"
    else
        printf 'Claude skill path already exists and was preserved: %s\n' "$claude_target"
        claude_target=""
    fi
fi

if [[ -n "$claude_target" ]]; then
    ln -s -- "../../.agents/skills/go-change-review" "$claude_target"
    printf 'Created Claude skill link: %s\n' "$claude_target"
fi

if [[ ! -e "$target_dir/opencode.json" && ! -e "$target_dir/opencode.jsonc" ]]; then
    cp -- "$script_dir/config-snippets/opencode-manual-only.jsonc" \
        "$target_dir/opencode.jsonc"
    printf 'Created OpenCode config: %s\n' "$target_dir/opencode.jsonc"
else
    cat <<EOF

OpenCode configuration already exists and was preserved.
Merge:

  $script_dir/config-snippets/opencode-manual-only.jsonc

into the existing project opencode.json or opencode.jsonc.
EOF
fi

if [[ ! -e "$target_dir/.pi/settings.json" ]]; then
    mkdir -p "$target_dir/.pi"
    cp -- "$script_dir/config-snippets/pi-settings.json" \
        "$target_dir/.pi/settings.json"
    printf 'Created Pi settings: %s\n' "$target_dir/.pi/settings.json"
else
    cat <<EOF

Pi project settings already exist and were preserved.
Merge:

  $script_dir/config-snippets/pi-settings.json

into:

  $target_dir/.pi/settings.json
EOF
fi

cat <<'EOF'

Manual invocation commands:

  Claude Code:
    /go-change-review Review current Go changes.

  Codex:
    $go-change-review Review current Go changes.

  Pi:
    /skill:go-change-review Review current Go changes.

  OpenCode:
    /go-change-review Review current Go changes.

Restart active coding-agent sessions after installation.
EOF
