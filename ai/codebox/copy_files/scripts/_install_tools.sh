#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


####
npm install -g markdownlint-cli bash-language-server yaml-language-server \
    pyright vscode-langservers-extracted typescript typescript-language-server \
    @vue/language-server eslint prettier prettier-plugin-tailwindcss

pip install --no-cache-dir --upgrade \
    python-docx python-pptx openpyxl pandas \
    pypdf pdfplumber pymupdf \
    ast-grep-cli
# $ ast-grep

####
mkdir -p /etc/apt/keyrings

curl -fsSL https://repo.charm.sh/apt/gpg.key | gpg --dearmor -o /etc/apt/keyrings/charm.gpg

echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" |
  tee /etc/apt/sources.list.d/charm.list

/opt/scripts/apt_install.sh dos2unix bash-completion \
  sqlite3 postgresql-client \
  ripgrep fd-find bat sd \
  fzf glow gum gh
# $ rg, bat, fdfind, sd
# go install github.com/charmbracelet/glow/v2@latest

ln -s /usr/bin/batcat /usr/bin/bat

####
tag_name=$(curl -fsSL https://api.github.com/repos/Wilfred/difftastic/releases/latest | jq -r .tag_name)
curl -fL -o difft.tar.gz "https://github.com/Wilfred/difftastic/releases/download/$tag_name/difft-x86_64-unknown-linux-gnu.tar.gz"
tar -xf difft.tar.gz -C /usr/local/bin/
chmod a+x /usr/local/bin/difft
rm -rf difft.tar.gz
# $ difft

# https://github.com/eza-community/eza/releases/download/v0.23.4/eza_x86_64-unknown-linux-gnu.tar.gz
# https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz
tag_name=$(curl -fsSL https://api.github.com/repos/eza-community/eza/releases/latest | jq -r .tag_name)
curl -fL -o eza.tar.gz "https://github.com/eza-community/eza/releases/download/$tag_name/eza_x86_64-unknown-linux-gnu.tar.gz"
tar -xf eza.tar.gz -C /usr/local/bin/ && \
chmod a+x /usr/local/bin/eza && \
rm -f eza.tar.gz
# $ eza

# https://github.com/TomWright/dasel/releases/download/v3.4.1/dasel_linux_amd64
tag_name=$(curl -fsSL https://api.github.com/repos/TomWright/dasel/releases/latest | jq -r .tag_name)
curl -fL -o /usr/local/bin/dasel "https://github.com/TomWright/dasel/releases/download/$tag_name/dasel_linux_amd64"
chmod a+x /usr/local/bin/dasel

#?? gitleaks, lazygit
