#!/usr/bin/env bash
# hc_wrapper.sh
# 用法: ./hc_wrapper.sh <script_path> [args...]
# 目标脚本内需包含一行，例如：
#   # HEALTHCHECK_UUID=12345678-1234-1234-1234-1234567890ab

set -euo pipefail

# ---- config ----
HC_BASE_URL="${HC_BASE_URL:-https://hc-ping.com}"
CURL_OPTS=(-fsS -m 10 --retry 5)
# ---------------

if [ $# -lt 1 ]; then
  echo "用法: $0 <script_path> [args...]"
  exit 1
fi

script=$1; shift || true

# 提取 UUID（支持注释或变量形式）
# 例：HEALTHCHECK_UUID=... 或 # HEALTHCHECK_UUID=...
uuid="$(grep -Eo 'HEALTHCHECK_UUID=[0-9a-f-]+' "$script" | head -n1 | cut -d= -f2 || true)"

if [ -z "${uuid:-}" ]; then
  echo "未在 $script 中找到 HEALTHCHECK_UUID"
  exit 2
fi

hc_url="${HC_BASE_URL%/}/${uuid}"

started=0
reported=0

ping() {
  # $1: 追加的路径，如 "", "/start", "/fail"
  curl "${CURL_OPTS[@]}" "${hc_url}$1" >/dev/null 2>&1 || true
}

# 退出/错误时的兜底：若已start但尚未显式上报，则发 /fail
on_exit() {
  local code=$?
  if [ "$started" -eq 1 ] && [ "$reported" -eq 0 ]; then
    if [ $code -ne 0 ]; then
      ping "/fail"
    fi
  fi
  exit $code
}
trap on_exit EXIT
trap 'exit 130' INT      # Ctrl-C
trap 'exit 143' TERM     # kill/terminate

# 执行前上报 start
ping "/start"
started=1

# 执行目标脚本
"$script" "$@" || status=$? || true
status=${status:-0}

# 成功/失败上报
if [ $status -eq 0 ]; then
  ping ""
else
  ping "/fail"
fi
reported=1

exit $status
