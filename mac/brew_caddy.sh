#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)

## caddy
brew install caddy

brew services start caddy

caddy hash-password --plaintext 'YOUR_BROWSER_PASSWORD'

:11234 {

    # API key 正确 → 直接进入 MLX
    @api {
        header Authorization "Bearer YOUR_API_KEY"
    }
    handle @api {
        reverse_proxy 127.0.0.1:11235
    }

    # 其余访问 → Basic Auth
    handle {
        basic_auth {
            leonard $2a$14$YOUR_HASH_HERE
        }

        reverse_proxy 127.0.0.1:11235
    }
}
