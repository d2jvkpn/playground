#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-}"
X="${2:-}"
Y="${3:-}"
WIDTH="${4:-}"
HEIGHT="${5:-}"

TIMESTAMP="$(date +%Y-%m-%d-%s)"
OUTPUT_DIR="${HOME}/Pictures"
FILE_NAME="screenshot.${TIMESTAMP}.png"
OUTPUT_FILE="${OUTPUT_DIR}/${FILE_NAME}"
TMP_FILE="/tmp/openclaw-screenshot.${TIMESTAMP}.png"

mkdir -p "$OUTPUT_DIR"

json_escape() {
  local s="${1:-}"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//$'\n'/\\n}"
  s="${s//$'\r'/\\r}"
  s="${s//$'\t'/\\t}"
  printf '%s' "$s"
}

print_json() {
  local code="${1:-1}"
  local msg="${2:-}"
  local name="${3:-}"
  local path="${4:-}"
  printf '{"code":%s,"msg":"%s","name":"%s","path":"%s"}\n' \
    "$code" \
    "$(json_escape "$msg")" \
    "$(json_escape "$name")" \
    "$(json_escape "$path")"
}

fail() {
  local code="${1:-1}"
  shift || true
  local msg="${*:-Unknown error}"
  print_json "$code" "$msg" "" ""
  exit "$code"
}

success() {
  local msg="${1:-Success}"
  print_json 0 "$msg" "$FILE_NAME" "$OUTPUT_FILE"
  exit 0
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail 1 "Missing command: $1"
}

cleanup() {
  rm -f "$TMP_FILE"
}
trap cleanup EXIT

need_cmd gnome-screenshot

if [[ -z "${DISPLAY:-}" && -z "${WAYLAND_DISPLAY:-}" ]]; then
  fail 2 "No graphical session detected. DISPLAY/WAYLAND_DISPLAY is not set."
fi

crop_image() {
  local input="$1"
  local output="$2"
  local x="$3"
  local y="$4"
  local w="$5"
  local h="$6"

  if command -v magick >/dev/null 2>&1; then
    magick "$input" -crop "${w}x${h}+${x}+${y}" +repage "$output" \
      || fail 6 "ImageMagick crop failed with magick"
  elif command -v convert >/dev/null 2>&1; then
    convert "$input" -crop "${w}x${h}+${x}+${y}" +repage "$output" \
      || fail 6 "ImageMagick crop failed with convert"
  else
    fail 5 "Area mode requires ImageMagick (magick or convert)"
  fi
}

case "$MODE" in
  fullscreen)
    gnome-screenshot -f "$OUTPUT_FILE" \
      || fail 3 "gnome-screenshot fullscreen command failed"

    [[ -f "$OUTPUT_FILE" ]] \
      || fail 3 "Fullscreen screenshot command finished but output file was not created"

    success "Captured fullscreen screenshot successfully"
    ;;

  window)
    gnome-screenshot -w -f "$OUTPUT_FILE" \
      || fail 3 "gnome-screenshot window command failed"

    [[ -f "$OUTPUT_FILE" ]] \
      || fail 3 "Window screenshot failed or no output file was created"

    success "Captured current window screenshot successfully"
    ;;

  area)
    [[ -n "$X" && -n "$Y" && -n "$WIDTH" && -n "$HEIGHT" ]] \
      || fail 4 "Area mode requires 4 parameters: x y width height"

    [[ "$X" =~ ^[0-9]+$ ]] || fail 4 "x must be a non-negative integer"
    [[ "$Y" =~ ^[0-9]+$ ]] || fail 4 "y must be a non-negative integer"
    [[ "$WIDTH" =~ ^[0-9]+$ ]] || fail 4 "width must be a positive integer"
    [[ "$HEIGHT" =~ ^[0-9]+$ ]] || fail 4 "height must be a positive integer"

    (( WIDTH > 0 )) || fail 4 "width must be greater than 0"
    (( HEIGHT > 0 )) || fail 4 "height must be greater than 0"

    gnome-screenshot -f "$TMP_FILE" \
      || fail 3 "gnome-screenshot fullscreen command for area capture failed"

    [[ -f "$TMP_FILE" ]] \
      || fail 3 "Temporary fullscreen screenshot for area crop was not created"

    crop_image "$TMP_FILE" "$OUTPUT_FILE" "$X" "$Y" "$WIDTH" "$HEIGHT"

    [[ -f "$OUTPUT_FILE" ]] \
      || fail 6 "Area crop failed or no output file was created"

    success "Captured area screenshot successfully"
    ;;

  *)
    fail 9 "Usage: take_screenshot.sh fullscreen | window | area <x> <y> <width> <height>"
    ;;
esac
