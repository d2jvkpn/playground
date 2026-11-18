#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


##
npm install -g --allow-scripts=core-js \
    markdownlint-cli bash-language-server yaml-language-server \
    pyright vscode-langservers-extracted typescript typescript-language-server \
    @vue/language-server eslint prettier prettier-plugin-tailwindcss npm-check-updates \
    @firecrawl/pdf-inspector
# pdf-inspector annual-report.pdf

pip install --no-cache-dir --upgrade markdownify ast-grep-cli \
    odfpy pandas pillow polars lxml beautifulsoup4 fonttools \
    python-docx python-pptx openpyxl \
    pypdf pdfplumber pymupdf poppler-utils

# pip install pdf-inspector


##
mkdir -p /etc/apt/keyrings

curl -fsSL https://repo.charm.sh/apt/gpg.key | gpg --dearmor -o /etc/apt/keyrings/charm.gpg

echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" |
  tee /etc/apt/sources.list.d/charm.list

/opt/scripts/apt.sh update

/opt/scripts/apt.sh install dos2unix \
  sqlite3 postgresql-client redis-tools \
  ripgrep fd-find bat sd \
  fzf glow gum htop
# htop, pandoc
# $ rg, bat, fdfind, sd
# go install github.com/charmbracelet/glow/v2@latest

ln -s /usr/bin/batcat /usr/bin/bat


## nerd-fonts
/opt/scripts/apt.sh install curl unzip fontconfig

mkdir -p /usr/local/share/fonts/nerd-fonts

curl -fL \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip \
  -o /tmp/JetBrainsMono.zip

unzip -o /tmp/JetBrainsMono.zip '*.ttf' -d /usr/local/share/fonts/nerd-fonts

fc-cache -fv

rm /tmp/JetBrainsMono.zip


##
/opt/scripts/apt.sh clean
rm -rf ~/.cache/* ~/.npm
