#!/usr/bin/env bash
set -euo pipefail

CITY="Shanghai"
PUSHOVER_SCRIPT="/home/appuser/.openclaw/workspace/skills/pushover/scripts/run.sh"
JSON_TMP="$(mktemp)"
trap 'rm -f "$JSON_TMP"' EXIT

curl -s "https://wttr.in/${CITY}?format=j1" > "$JSON_TMP"

message="$(python3 - "$JSON_TMP" <<'PY'
import json, sys, datetime
from pathlib import Path

p = Path(sys.argv[1])
j = json.loads(p.read_text(encoding='utf-8'))
weather = j.get('weather', [])[:3]
cn_tz = datetime.timezone(datetime.timedelta(hours=8))
now = datetime.datetime.now(cn_tz).strftime('%Y-%m-%d %H:%M CST')

# 中文星期映射
weekday_cn = ['周一', '周二', '周三', '周四', '周五', '周六', '周日']

lines = [f'Shanghai 未来 3 天天气（{now}）']
for idx, d in enumerate(weather):
    date_str = d.get('date', '')
    # 解析日期字符串为 datetime 对象
    try:
        date_obj = datetime.datetime.strptime(date_str, '%Y-%m-%d').date()
        weekday = weekday_cn[date_obj.weekday()]
        date_with_week = f'{date_str} ({weekday})'
    except:
        date_with_week = date_str
    
    maxc = d.get('maxtempC', '')
    minc = d.get('mintempC', '')
    hourly = d.get('hourly', [])
    desc = ''
    if hourly:
        pick = hourly[min(4, len(hourly)-1)]
        desc = ((pick.get('weatherDesc') or [{}])[0].get('value') or '').strip()
    lines.append(f'{date_with_week}: {desc}, {minc}~{maxc}°C')
print('\n'.join(lines))
PY
)"

title="Shanghai 天气" message="$message" "$PUSHOVER_SCRIPT"
printf '%s\n' "$message"
