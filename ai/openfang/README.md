# OpenFang
---


#### 1. 
- https://github.com/RightNow-AI/openfang
- https://www.openfang.sh


#### 2.
```
curl -X POST http://localhost:4200/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $token" \
  -d '{
    "model": "researcher",
    "messages": [
      {"role": "user", "content": "讲一个笑话"}
    ],
    "stream": false,
    "max_tokens": 64
  }'
```

```
img_b64=$(base64 -w 0 ./data/test01.jpg)

curl --max-time 120 -X POST http://localhost:4200/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $token" \
  -d "$(jq -n \
    --arg model "openfang:Assistant" \
    --arg text "请描述这张图片。" \
    --arg image "data:image/jpeg;base64,$img_b64" \
    '{
      model: $model,
      messages: [
        {
          role: "user",
          content: [
            { type: "text", text: $text },
            { type: "image_url", image_url: { url: $image } }
          ]
        }
      ],
      stream: false,
      max_tokens: 512
    }'
  )"
```
