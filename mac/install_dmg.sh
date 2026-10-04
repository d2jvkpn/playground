#!/usr/bin/env bash
# install_dmg.sh — One-liner dmg installer for macOS
# Usage: ./install_dmg.sh /path/to/file.dmg

set -euo pipefail

# ---------- Colors ----------
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()    { echo -e "${GREEN}[INFO]${NC} $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }

# ---------- Argument check ----------
DMG_PATH="${1:?Usage: $0 <file.dmg>}"

if [[ ! -f "$DMG_PATH" ]]; then
    error "File not found: $DMMG_PATH"
    exit 1
fi

# ---------- Mount the dmg ----------
VOLUME_NAME=$(hdiutil attach "$DMG_PATH" -nobrowse -noautoopen 2>/dev/null | awk '/\/Volumes\//{print $NF}' | head -n1)

if [[ -z "$VOLUME_NAME" ]]; then
    error "Failed to mount dmg. Please verify the file is valid."
    hdiutil detach "$DMG_PATH" >/dev/null 2>&1 || true
    exit 1
fi

# ---------- Find .app bundle ----------
APP_NAME=""
while IFS= read -r match; do
    APP_NAME="$match"
done < <(find "/Volumes/$VOLUME_NAME" -maxdepth 1 -name '*.app' 2>/dev/null)

if [[ -z "$APP_NAME" ]]; then
    warn "No .app found at /Volumes/$VOLUME_NAME. Contents:"
    ls "/Volumes/$VOLUME_NAME"

    # Fallback: install pkg if present
    PKG=$(find "/Volumes/$VOLUME_NAME" -maxdepth 1 -name '*.pkg' 2>/dev/null | head -n1)
    if [[ -n "$PKG" ]]; then
        info "Found a .pkg, installing with installer..."
        sudo installer -pkg "$PKG" -target /
    fi
    hdiutil detach "/Volumes/$VOLUME_NAME" >/dev/null 2>&1 || true
    exit 0
fi

# ---------- Copy to Applications ----------
TARGET="/Applications/${APP_NAME##*/}"
if [[ -d "$TARGET" ]]; then
    warn "$TARGET already exists, will overwrite..."
    sudo rm -rf "$TARGET"
fi

info "Copying ${APP_NAME##*/} to /Applications/ ..."
sudo cp -R "/Volumes/$VOLUME_NAME/$APP_NAME" "$TARGET"

# ---------- Cleanup ----------
info "Unmounting dmg..."
hdiutil detach "/Volumes/$VOLUME_NAME" >/dev/null 2>&1 || true

# ---------- Remove quarantine attribute ----------
info "Removing quarantine attribute..."
xattr -d com.apple.quarantine "$TARGET" 2>/dev/null || true

info "✅ Done: $TARGET"
