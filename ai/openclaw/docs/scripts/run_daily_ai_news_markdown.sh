#!/usr/bin/env bash
set -euo pipefail

workspace="/home/appuser/.openclaw/workspace"
AI_NEWS_SOURCE="api=SerpAPI; query=AI OR artificial intelligence; engine=google_news; country=us; lang=en; num=100"
outdir="$workspace/ai-news"
mkdir -p "$outdir"
filename="$(date +%F-%s).md"
out="$outdir/$filename"
url="https://http-md.cn.x-rover.top/docs/ai-news/$filename"

# fetch_ai_news.sh outputs file path, read its content
news_file="$($workspace/scripts/fetch_ai_news.sh | head -1)"
raw="$(cat "$news_file" 2>/dev/null || echo '')"

filtered="$({ printf '%s\n' "$raw" | awk '
  BEGIN { started=0 }
  /^#### / { started=1 }
  {
    if (started) print
  }
'; } )"

count="$(printf '%s\n' "$filtered" | grep -c '^#### ' || true)"

content="$({
  printf '## AI News(last 24 hours)\n'
  printf -- '- executed_at: %s\n' "$(date '+%F %T %Z')"
  printf -- '- source: %s\n' "$AI_NEWS_SOURCE"
  printf -- '- window: last 24 hours\n'
  printf -- '- count: %s\n\n' "$count"

  printf '%s\n' "$filtered" | awk '
    /^#### / {
      sub(/^#### [0-9]+\. /, "", $0)
      print ++n ". **" $0 "**"
      next
    }
    /^- source:/ {
      sub(/^- source:/, "* source:", $0)
      print
      next
    }
    /^- time:/ {
      sub(/^- time:/, "* time:", $0)
      print
      next
    }
    /^- snippet:/ {
      sub(/^- snippet:/, "* snippet:", $0)
      print
      next
    }
    /^- href:/ {
      sub(/^- href:/, "* href:", $0)
      print
      print ""
      next
    }
  '
} )"

printf '%s\n' "$content" > "$out"

summary="$(printf '%s\n' "$filtered" | awk '
  /^#### / {
    sub(/^#### [0-9]+\. /, "", $0)
    titles[++n]=$0
    if (n==3) exit
  }
  END {
    for (i=1; i<=n; i++) print i ". " titles[i]
  }
')"

# 构建通知消息：链接 + 新闻列表
# 使用 $'...' 语法确保换行符被正确解释
message=""
if [[ -n "$url" ]]; then
  message+="$url"$'\n'
fi
if [[ -n "$summary" ]]; then
  message+="$summary"
fi

# 检查消息长度（Pushover限制1024字符）
msg_len="${#message}"
if [[ $msg_len -gt 1000 ]]; then
  # 如果太长，只保留链接和前2条新闻
  message="$url"$'\n'
  short_summary="$(printf '%s\n' "$summary" | head -2)"
  message+="$short_summary"
fi

title="daily-ai-news-markdown" \
message="$message" \
"$workspace/skills/pushover/scripts/run.sh"

printf 'OK\n%s\n%s\n' "$out" "$url"
