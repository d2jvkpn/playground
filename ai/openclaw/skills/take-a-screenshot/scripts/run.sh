#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-}"
X="${2:-}"
Y="${3:-}"
WIDTH="${4:-}"
HEIGHT="${5:-}"

TIMESTAMP="$(date +%Y-%m-%d-%s)"
OUTPUT_DIR="${HOME}/Pictures"
OUTPUT_FILE="${OUTPUT_DIR}/screenshot.${TIMESTAMP}.png"
TMP_FILE="/tmp/openclaw-screenshot.${TIMESTAMP}.png"

mkdir -p "$OUTPUT_DIR"

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "Missing command: $1"
}

cleanup() {
  rm -f "$TMP_FILE"
}
trap cleanup EXIT

need_cmd gnome-screenshot

if [[ -z "${DISPLAY:-}" && -z "${WAYLAND_DISPLAY:-}" ]]; then
  fail "No graphical session detected. DISPLAY/WAYLAND_DISPLAY is not set."
fi

crop_image() {
  local input="$1"
  local output="$2"
  local x="$3"
  local y="$4"
  local w="$5"
  local h="$6"

  if command -v magick >/dev/null 2>&1; then
    magick "$input" -crop "${w}x${h}+${x}+${y}" +repage "$output"
  elif command -v convert >/dev/null 2>&1; then
    convert "$input" -crop "${w}x${h}+${x}+${y}" +repage "$output"
  else
    fail "Area mode requires ImageMagick (`magick` or `convert`)."
  fi
}

case "$MODE" in
  fullscreen)
    gnome-screenshot -f "$OUTPUT_FILE"
    [[ -f "$OUTPUT_FILE" ]] || fail "Screenshot command finished but output file was not created."
    echo "$OUTPUT_FILE"
    ;;

  window)
    gnome-screenshot -w -f "$OUTPUT_FILE"
    [[ -f "$OUTPUT_FILE" ]] || fail "Window screenshot failed or no output file was created."
    echo "$OUTPUT_FILE"
    ;;

  area)
    [[ -n "$X" && -n "$Y" && -n "$WIDTH" && -n "$HEIGHT" ]] || \
      fail "Area mode requires 4 parameters: x y width height"

    [[ "$X" =~ ^[0-9]+$ ]] || fail "x must be a non-negative integer"
    [[ "$Y" =~ ^[0-9]+$ ]] || fail "y must be a non-negative integer"
    [[ "$WIDTH" =~ ^[0-9]+$ ]] || fail "width must be a positive integer"
    [[ "$HEIGHT" =~ ^[0-9]+$ ]] || fail "height must be a positive integer"

    (( WIDTH > 0 )) || fail "width must be > 0"
    (( HEIGHT > 0 )) || fail "height must be > 0"

    gnome-screenshot -f "$TMP_FILE"
    [[ -f "$TMP_FILE" ]] || fail "Fullscreen screenshot for area crop failed."

    crop_image "$TMP_FILE" "$OUTPUT_FILE" "$X" "$Y" "$WIDTH" "$HEIGHT"
    [[ -f "$OUTPUT_FILE" ]] || fail "Area crop failed or no output file was created."
    echo "$OUTPUT_FILE"
    ;;

  *)
    cat >&2 <<'EOF'
Usage:
  #take_screenshot.sh fullscreen
  run.sh window
  run.sh area <x> <y> <width> <height>

Examples:
  run.sh fullscreen
  run.sh window
  run.sh area 100 200 800 600
EOF
    exit 2
    ;;
esac
