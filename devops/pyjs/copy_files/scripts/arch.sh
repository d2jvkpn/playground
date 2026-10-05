
RAW_ARCH="$(uname -m)"

case "$RAW_ARCH" in
  x86_64|amd64)
    ARCH=amd64
    ARCH_GNU=x86_64
    ARCH_NODE=x64
    ;;
  arm64|aarch64)
    ARCH=arm64
    ARCH_GNU=aarch64
    ARCH_NODE=arm64
    ;;
  *)
    echo "Unsupported architecture: $RAW_ARCH" >&2
    return 1
    ;;
esac

export RAW_ARCH ARCH ARCH_GNU ARCH_NODE
