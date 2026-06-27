# Title
---


#### 1. 
1. commands
```
zeroclaw status
zeroclaw config get gateway.port
zeroclaw config get gateway.host

zeroclaw gateway --host 127.0.0.1 --port 42617

zeroclaw agent -a default -m "你好，介绍一下你的能力"

curl -s -X POST http://127.0.0.1:42617/admin/paircode/new

curl -X POST http://127.0.0.1:42617/pair \
  -H "X-Pairing-Code: <$pairing_code>"

curl -X POST http://127.0.0.1:42617/webhook \
  -H "Authorization: Bearer $token" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "你好!"
  }'


curl http://127.0.0.1:42617/v1/models \
  -H "Authorization: Bearer $token"

curl -X POST http://127.0.0.1:42617/v1/chat/completions \
  -H "Authorization: Bearer $token" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "default",
    "messages": [
      {"role": "user", "content": "你好，介绍一下你的能力"}
    ],
    "stream": false
  }'
```
