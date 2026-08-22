#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


####
npm install -g markdownlint-cli bash-language-server yaml-language-server \
    pyright vscode-langservers-extracted typescript typescript-language-server \
    @vue/language-server eslint prettier prettier-plugin-tailwindcss npm-check-updates

pip install --no-cache-dir --upgrade markdownify ast-grep-cli \
    odfpy pandas pillow polars lxml beautifulsoup4 \
    python-docx python-pptx openpyxl \
    pypdf pdfplumber pymupdf poppler-utils

####
mkdir -p /etc/apt/keyrings

curl -fsSL https://repo.charm.sh/apt/gpg.key | gpg --dearmor -o /etc/apt/keyrings/charm.gpg

echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" |
  tee /etc/apt/sources.list.d/charm.list

/opt/scripts/apt_install.sh dos2unix bash-completion \
  sqlite3 postgresql-client redis-tools \
  ripgrep fd-find bat sd \
  fzf glow gum gh htop rsync
# bubblewrap, htop, pandoc
# $ rg, bat, fdfind, sd
# go install github.com/charmbracelet/glow/v2@latest

ln -s /usr/bin/batcat /usr/bin/bat

####
echo "==> Installing difft"
tag_name=$(curl -fsSL https://api.github.com/repos/Wilfred/difftastic/releases/latest | jq -r .tag_name)
prefix=difft-x86_64-unknown-linux-gnu
curl -fL -o $prefix.tar.gz \
  "https://github.com/Wilfred/difftastic/releases/download/$tag_name/$prefix.tar.gz"
tar -xf $prefix.tar.gz -C /usr/local/bin/
chmod a+x /usr/local/bin/difft
rm -rf $prefix.tar.gz
# $ difft

echo "==> Installing eza"
# https://github.com/eza-community/eza/releases/download/v0.23.4/eza_x86_64-unknown-linux-gnu.tar.gz
# https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz
tag_name=$(curl -fsSL https://api.github.com/repos/eza-community/eza/releases/latest | jq -r .tag_name)
prefix=eza_x86_64-unknown-linux-gnu
curl -fL -o $prefix.tar.gz \
  "https://github.com/eza-community/eza/releases/download/$tag_name/$prefix.tar.gz"
tar -xf $prefix.tar.gz -C /usr/local/bin/ && \
chmod a+x /usr/local/bin/eza && \
rm -f $prefix.tar.gz
# $ eza

echo "==> Installing dasel"
# https://github.com/TomWright/dasel/releases/download/v3.4.1/dasel_linux_amd64
tag_name=$(curl -fsSL https://api.github.com/repos/TomWright/dasel/releases/latest | jq -r .tag_name)
curl -fL -o /usr/local/bin/dasel \
  "https://github.com/TomWright/dasel/releases/download/$tag_name/dasel_linux_amd64"
chmod a+x /usr/local/bin/dasel

echo "==> Installing lazygit"
# https://github.com/jesseduffield/lazygit/releases/download/v0.62.2/lazygit_0.62.2_linux_x86_64.tar.gz
tag_name=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | jq -r .tag_name)
prefix=lazygit_${tag_name#v}_linux_x86_64
curl -fL -o $prefix.tar.gz \
  "https://github.com/jesseduffield/lazygit/releases/download/$tag_name/$prefix.tar.gz"
tar -xvf $prefix.tar.gz -C /usr/local/bin/ lazygit
rm -f $prefix.tar.gz

echo "==> Installing delta"
tag_name=$(curl -fsSL https://api.github.com/repos/dandavison/delta/releases/latest | jq -r .tag_name)
prefix=delta-${tag_name}-x86_64-unknown-linux-gnu
curl -fL -o $prefix.tar.gz \
    "https://github.com/dandavison/delta/releases/download/$tag_name/$prefix.tar.gz"
tar -xf $prefix.tar.gz
mv $prefix/delta /usr/local/bin/
rm -r $prefix $prefix.tar.gz

echo "==> Installing difft"
tag_name=$(curl -fsSL https://api.github.com/repos/Wilfred/difftastic/releases/latest | jq -r .tag_name)
prefix=difft-x86_64-unknown-linux-gnu
curl -fL -o $prefix.tar.gz \
  https://github.com/Wilfred/difftastic/releases/download/${tag_name}/$prefix.tar.gz
tar -xvf $prefix.tar.gz -C /usr/local/bin/
rm -f $prefix.tar.gz

echo "==> Installing golangci-lint"
tag_name=$(curl -fsSL https://api.github.com/repos/golangci/golangci-lint/releases/latest | jq -r .tag_name)
prefix=golangci-lint-${tag_name#v}-linux-amd64
curl -fL -o $prefix.tar.gz \
  https://github.com/golangci/golangci-lint/releases/download/${tag_name}/$prefix.tar.gz
tar -xf $prefix.tar.gz
mv $prefix/golangci-lint /usr/local/bin/
rm -rf $prefix.tar.gz $prefix

#?? gitleaks
#go install github.com/air-verse/air@latest

####
rm -rf ~/.cache/* ~/.npm
