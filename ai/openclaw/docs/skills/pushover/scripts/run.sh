#!/usr/bin/env bash
set -euo pipefail

config_yaml="${config_yaml:-$HOME/.config/pushover_notify/local.yaml}"
yq_bin="${yq_bin:-$(command -v yq)}"
curl_bin="${curl_bin:-$(command -v curl)}"

title="${title:-}"
message="${message:-}"

log() {
  printf '[pushover] %s\n' "$*" >&2
}

now_iso="$(date -Iseconds)"

get_pushover_cfg() {
  local expr="$1"
  if [[ ! -f "$config_yaml" ]]; then
    printf ''
    return 0
  fi
  "$yq_bin" -r "$expr // \"\"" "$config_yaml" 2>/dev/null || true
}

pushover_token="$(get_pushover_cfg '.pushover.app_token')"
pushover_user="$(get_pushover_cfg '.pushover.user_key')"
pushover_device="$(get_pushover_cfg '.pushover.device')"

send_pushover() {
  local title="$1"
  local message="$2"

  if [[ -z "$pushover_token" || -z "$pushover_user" ]]; then
    log "pushover credentials missing in $config_yaml; skipping notification"
    return 1
  fi

  local -a args=(
    -fsS https://api.pushover.net/1/messages.json
    --form-string "token=$pushover_token"
    --form-string "user=$pushover_user"
    --form-string "title=$title"
    --form-string "message=$message"
  )

  if [[ -n "$pushover_device" ]]; then
    args+=(--form-string "device=$pushover_device")
  fi

  "$curl_bin" "${args[@]}" >/dev/null
}

send_pushover "OpenClaw: $title" "$message"
log "pushover sent notification"
