#!/usr/bin/env bash
set -euo pipefail

WORKSPACE="${OPENCLAW_WORKSPACE:-$HOME/.openclaw/workspace}"
STATE_FILE="${STATE_FILE:-$WORKSPACE/state/github-release-watch.yaml}"
PUSHOVER_SCRIPT="${PUSHOVER_SCRIPT:-$WORKSPACE/skills/pushover/scripts/run.sh}"
YQ_BIN="${YQ_BIN:-$(command -v yq)}"
CURL_BIN="${CURL_BIN:-$(command -v curl)}"

log() {
  printf '[github-release-watch] %s\n' "$*" >&2
}

require_bin() {
  command -v "$1" >/dev/null 2>&1 || {
    log "missing required binary: $1"
    exit 1
  }
}

require_bin "$YQ_BIN"
require_bin "$CURL_BIN"
require_bin "$PUSHOVER_SCRIPT"

mkdir -p "$(dirname "$STATE_FILE")"

if [[ ! -f "$STATE_FILE" ]]; then
  cat >"$STATE_FILE" <<'YAML'
repositories:
  - repository: openclaw/openclaw
    enabled: true
    latest:
      version: ""
      source: ""
      checked_at: ""
  - repository: anomalyco/opencode
    enabled: true
    latest:
      version: ""
      source: ""
      checked_at: ""
last_run_at: ""
last_notify_at: ""
YAML
fi

now_iso="$(date -Iseconds)"

send_pushover() {
  local title="$1"
  local message="$2"

  title="$title" message="$message" "$PUSHOVER_SCRIPT"
}

# --- Error trap: notify on script failure ---
trap_err() {
  local rc=$?
  send_pushover "检测任务失败" \
    "github-release-watch 异常退出 (exit $rc)
命令: ${BASH_COMMAND:0:120}
行号: $LINENO"
}
trap 'trap_err' ERR

fetch_latest_release_json() {
  local repository="$1"
  local url="https://api.github.com/repos/$repository/releases/latest"
  "$CURL_BIN" -fsS \
    -H 'Accept: application/vnd.github+json' \
    -H 'User-Agent: openclaw-release-watch' \
    "$url"
}

fetch_latest_tag_json() {
  local repository="$1"
  local url="https://api.github.com/repos/$repository/tags?per_page=1"
  "$CURL_BIN" -fsS \
    -H 'Accept: application/vnd.github+json' \
    -H 'User-Agent: openclaw-release-watch' \
    "$url"
}

repository_count="$($YQ_BIN -r '.repositories | length' "$STATE_FILE")"
updates=()
state_updated=false

for ((i=0; i<repository_count; i++)); do
  enabled="$($YQ_BIN -r ".repositories[$i].enabled // true" "$STATE_FILE")"
  [[ "$enabled" == "true" ]] || continue

  repository="$($YQ_BIN -r ".repositories[$i].repository" "$STATE_FILE")"
  previous_version="$($YQ_BIN -r ".repositories[$i].latest.version // \"\"" "$STATE_FILE")"

  latest_version=""
  source=""

  if release_json="$(fetch_latest_release_json "$repository" 2>/dev/null)"; then
    latest_version="$(printf '%s' "$release_json" | "$YQ_BIN" -r '.tag_name // .name // ""' -)"
    source="release"
  fi

  if [[ -z "$latest_version" || "$latest_version" == "null" ]]; then
    if tags_json="$(fetch_latest_tag_json "$repository" 2>/dev/null)"; then
      latest_version="$(printf '%s' "$tags_json" | "$YQ_BIN" -r '.[0].name // ""' -)"
      source="tag"
    fi
  fi

  if [[ -z "$latest_version" || "$latest_version" == "null" ]]; then
    log "failed to resolve latest version for $repository"
    continue
  fi

  "$YQ_BIN" -i \
    ".repositories[$i].latest.version = \"$latest_version\" |
     .repositories[$i].latest.source = \"$source\" |
     .repositories[$i].latest.checked_at = \"$now_iso\"" \
    "$STATE_FILE"
  state_updated=true

  if [[ -n "$previous_version" && "$previous_version" != "$latest_version" ]]; then
    updates+=("$repository|$previous_version|$latest_version|$source")
  fi
done

if [[ "$state_updated" == true ]]; then
  "$YQ_BIN" -i ".last_run_at = \"$now_iso\"" "$STATE_FILE"
fi

if ((${#updates[@]} == 0)); then
  log "no new versions"
  exit 0
fi

message_lines=()
for item in "${updates[@]}"; do
  IFS='|' read -r repository old_version new_version source <<<"$item"
  releases_url="https://github.com/$repository/releases"
  message_lines+=("$repository: $old_version -> $new_version ($source)")
  message_lines+=("  $releases_url")
done

message="$(printf '%s\n' "${message_lines[@]}")"
send_pushover "github-release-watch" "$message"
"$YQ_BIN" -i ".last_notify_at = \"$now_iso\"" "$STATE_FILE"
log "sent notification for ${#updates[@]} update(s)"
