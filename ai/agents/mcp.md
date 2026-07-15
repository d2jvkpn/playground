# MCP
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```


#### ch01. 
1. markets
- https://mcpmarket.com

2. services
- https://mcpmarket.com/tools/skills/pushover-notifications
- https://mcpmarket.com/tools/skills/speech-to-text

3. 
```
curl -sS -X POST "$MCP_URL" \
  -H "MCP-Session-Id: $SESSION_ID" \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H "Accept: text/event-stream"  \
  -H 'MCP-Protocol-Version: 2025-11-25' \
  -d '{
    "jsonrpc": "2.0",
    "id": 2,
    "method": "tools/list",
    "params": {}
  }
```
