#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

. /opt/scripts/arch.sh

echo "==> Installing difft"
tag_name=$(curl -fsSL https://api.github.com/repos/Wilfred/difftastic/releases/latest | jq -r .tag_name)
#prefix=difft-${tag_name}-x86_64-unknown-linux-gnu
prefix=difft-${tag_name}-${RAW_ARCH}-unknown-linux-gnu
url="https://github.com/Wilfred/difftastic/releases/download/${tag_name}/$prefix.tar.gz"
echo "url: $url"
curl -fL -o $prefix.tar.gz $url
tar -xvf $prefix.tar.gz -C /usr/local/bin/
rm -f $prefix.tar.gz

echo "==> Installing eza"
# https://github.com/eza-community/eza/releases/download/v0.23.4/eza_x86_64-unknown-linux-gnu.tar.gz
# https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz
tag_name=$(curl -fsSL https://api.github.com/repos/eza-community/eza/releases/latest | jq -r .tag_name)
#prefix=eza_x86_64-unknown-linux-gnu
prefix=eza_${RAW_ARCH}-unknown-linux-gnu
url="https://github.com/eza-community/eza/releases/download/$tag_name/$prefix.tar.gz"
echo "url: $url"
curl -fL -o $prefix.tar.gz $url
tar -xf $prefix.tar.gz -C /usr/local/bin/
chmod a+x /usr/local/bin/eza && \
rm -f $prefix.tar.gz
# $ eza

echo "==> Installing dasel"
# https://github.com/TomWright/dasel/releases/download/v3.4.1/dasel_linux_amd64
tag_name=$(curl -fsSL https://api.github.com/repos/TomWright/dasel/releases/latest | jq -r .tag_name)
#prefix=dasel_linux_amd64
prefix=dasel_linux_${ARCH}
url="https://github.com/TomWright/dasel/releases/download/$tag_name/$prefix"
echo "url: $url"
curl -fL -o /usr/local/bin/dasel $url
chmod a+x /usr/local/bin/dasel

echo "==> Installing lazygit"
# https://github.com/jesseduffield/lazygit/releases/download/v0.62.2/lazygit_0.62.2_linux_x86_64.tar.gz
tag_name=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | jq -r .tag_name)
#prefix=lazygit_${tag_name#v}_linux_x86_64
if [[ "$ARCH" == "amd64" ]]; then
    prefix=lazygit_${tag_name#v}_linux_${ARCH_GNU} # "x84_64"
else
    prefix=lazygit_${tag_name#v}_linux_${ARCH}      # arm64
fi
url="https://github.com/jesseduffield/lazygit/releases/download/$tag_name/$prefix.tar.gz"
echo "url: $url"
curl -fL -o $prefix.tar.gz $url
tar -xvf $prefix.tar.gz -C /usr/local/bin/ lazygit
rm -f $prefix.tar.gz

echo "==> Installing delta"
tag_name=$(curl -fsSL https://api.github.com/repos/dandavison/delta/releases/latest | jq -r .tag_name)
#prefix=delta-${tag_name}-x86_64-unknown-linux-gnu
prefix=delta-${tag_name}-${RAW_ARCH}-unknown-linux-gnu
url="https://github.com/dandavison/delta/releases/download/$tag_name/$prefix.tar.gz"
echo "url: $url"
curl -fL -o $prefix.tar.gz $url
tar -xf $prefix.tar.gz
mv $prefix/delta /usr/local/bin/
rm -r $prefix $prefix.tar.gz

echo "==> Installing golangci-lint"
tag_name=$(curl -fsSL https://api.github.com/repos/golangci/golangci-lint/releases/latest | jq -r .tag_name)
#prefix=golangci-lint-${tag_name#v}-linux-amd64
prefix=golangci-lint-${tag_name#v}-linux-${ARCH}
url="https://github.com/golangci/golangci-lint/releases/download/${tag_name}/$prefix.tar.gz"
echo "url: $url"
curl -fL -o $prefix.tar.gz $url
tar -xf $prefix.tar.gz
mv $prefix/golangci-lint /usr/local/bin/
rm -rf $prefix.tar.gz $prefix

#?? gitleaks
#go install github.com/air-verse/air@latest
