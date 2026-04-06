# OpenClaw: Memory Search
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```


#### ch01. 
1. docs
- https://docs.openclaw.ai/concepts/memory
- https://huggingface.co/ggml-org/embeddinggemma-300m-qat-q8_0-GGUF/tree/main
- docs locations
```
workspace/
├─ MEMORY.md
├─ memory/
│  ├─ product.md
│  ├─ faq.md
│  └─ api.md
├─ docs/
│  ├─ intro.md
│  ├─ pricing.md
│  └─ integration.md
```
- sqlite location: ~/.openclaw/memory/<agentId>.sqlite

2. global memory search settings
```
{
  "agents": {
    "defaults": {
      "memorySearch": {
        "enabled": true,
        "provider": "local | openai | gemini",
        "local": {
          "modelPath": "hf:ggml-org/embeddinggemma-300M-GGUF/embeddinggemma-300M-Q8_0.gguf"
        },
        "remote": {
          "baseUrl": "https://dashscope.aliyuncs.com/compatible-mode/v1",
          "apiKey": "DASHSCOPE_API_KEY",
          "batch": { "enabled": true, "concurrency": 2 }
        },
        "model": "text-embedding-v4",
        "extraPaths": ["memory-search.docs"],
        "fallback": "none",
        "query": {
          "hybrid": {
             "enabled": true,
             "vectorWeight": 0.7,
             "textWeight": 0.3,
             "candidateMultiplier": 4
           }
         }
      }
    }
  }
}
```

3. memory search settings for a specified agent
```
{
  agents: {
    list: [
      {
        id: "assistant-agent-id",
        memorySearch: {
          enabled: true,
          sources: ["memory", "sessions"]
        },
        tools: {
          alsoAllow: ["group:memory"]
          #  alsoAllow: ["memory_search", "memory_get"]
        }
      }
    ]
  }
}
```

4. commands
```
openclaw memory status
openclaw memory index
openclaw memory search "your question...."
```
