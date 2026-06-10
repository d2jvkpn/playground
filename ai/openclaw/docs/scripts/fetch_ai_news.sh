#!/usr/bin/env bash
set -euo pipefail

WORKSPACE="/home/appuser/.openclaw/workspace"
SERP_SCRIPT="/home/appuser/.openclaw/skills/serpapi/scripts/search.sh"
PUSHOVER_SCRIPT="$WORKSPACE/skills/pushover/scripts/run.sh"
AI_NEWS_SOURCE="api=SerpAPI; query=AI OR artificial intelligence; engine=google_news; country=us; lang=en; num=100"
OUT_DIR="$WORKSPACE/ai-news"
mkdir -p "$OUT_DIR"

filename="$(date +%F-%s).md"
outfile="$OUT_DIR/$filename"
read_url="https://http-md.cn.x-rover.top/docs/ai-news/$filename"

json_tmp="$(mktemp)"
trap 'rm -f "$json_tmp"' EXIT

bash "$SERP_SCRIPT" "AI OR artificial intelligence" --engine google_news --country us --lang en --num 100 --json > "$json_tmp"

python3 - "$json_tmp" "$outfile" <<'PY'
import json, datetime, os, sys
from urllib.parse import urlparse
from pathlib import Path

json_path = Path(sys.argv[1])
out_path = Path(sys.argv[2])

data = json.loads(json_path.read_text(encoding='utf-8'))
items = data.get('news_results', [])
now_utc = datetime.datetime.now(datetime.timezone.utc)
cutoff = now_utc - datetime.timedelta(hours=24)
cn_tz = datetime.timezone(datetime.timedelta(hours=8))

results = []
for it in items:
    ds = (it.get('date') or '').strip()
    dt = None
    for fmt in ('%m/%d/%Y, %I:%M %p, %z UTC', '%m/%d/%Y, %I:%M %p, +0000 UTC'):
        try:
            dt = datetime.datetime.strptime(ds, fmt)
            break
        except Exception:
            pass
    if dt is None:
        continue
    if dt.tzinfo is None:
        dt = dt.replace(tzinfo=datetime.timezone.utc)
    dt = dt.astimezone(datetime.timezone.utc)
    if dt < cutoff:
        continue

    source = it.get('source')
    if isinstance(source, dict):
        source = source.get('name', '')

    results.append({
        'title': (it.get('title') or '').strip(),
        'source': source or '',
        'time': dt.astimezone(cn_tz).strftime('%Y-%m-%d %H:%M CST'),
        'snippet': (it.get('snippet') or '').strip(),
        'href': (it.get('link') or '').strip(),
    })

seen = set()
uniq = []
for r in sorted(results, key=lambda x: x['time'], reverse=True):
    key = (r['title'], r['href'])
    if key in seen:
        continue
    seen.add(key)
    uniq.append(r)

lines = []
lines.append('# AI 资讯（最近 24 小时）')
lines.append('')
lines.append(f'- executed_at: {now_utc.astimezone(cn_tz).strftime("%Y-%m-%d %H:%M CST")}')
lines.append(os.environ.get('AI_NEWS_SOURCE', 'api=SerpAPI; query=AI OR artificial intelligence; engine=google_news; country=us; lang=en; num=100'))
lines.append('- window: last 24 hours')
lines.append(f'- count: {min(20, len(uniq))}')
lines.append('')

for i, r in enumerate(uniq[:20], 1):
    lines.append(f'#### {i}. {r["title"]}')
    lines.append(f'- source: {r["source"]}')
    lines.append(f'- time: {r["time"]}')
    lines.append(f'- snippet: {r["snippet"]}')
    if r["href"]:
        domain = urlparse(r["href"]).netloc or r["href"]
        lines.append(f'- href: [{domain}]({r["href"]})')
    else:
        lines.append('- href:')
    lines.append('')

out_path.write_text('\n'.join(lines), encoding='utf-8')
PY

# 注释掉 Pushover 通知，由 run_daily_ai_news_markdown.sh 统一发送
# title="AI 资讯已生成" \
# message="今日 AI 新闻已保存。阅读地址：$read_url" \
# "$PUSHOVER_SCRIPT"

echo "$outfile"
echo "$read_url"
