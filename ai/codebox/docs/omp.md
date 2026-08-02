# Title
---


#### 1. config
```yaml  ~/.omp/agent/models.yml
providers:
  kimi-plan-api:
    baseUrl: https://api.kimi.com/coding/v1
    api: openai-completions
    apiKey: KIMI_CODE_API_KEY
    authHeader: true

    models:
      - id: k3-256k
        name: Kimi K3 256K
        reasoning: true
        contextWindow: 262144
        maxTokens: 32768

      - id: k3
        name: Kimi K3
        reasoning: true
        contextWindow: 1048576
        maxTokens: 32768

      - id: kimi-for-coding
        name: Kimi K2.7 Code
        reasoning: true
        contextWindow: 262144
        maxTokens: 32768

      - id: kimi-for-coding-highspeed
        name: Kimi K2.7 Code HighSpeed
        reasoning: true
        contextWindow: 262144
        maxTokens: 32768
```

#### 2. commands
- /login
- /logout
