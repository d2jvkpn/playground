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
- /compact

#### 3. config
```
omp config get compaction.enabled
omp config get compaction.strategy
omp config get compaction.thresholdPercent
omp config get compaction.thresholdTokens
omp config get compaction.reserveTokens
omp config get compaction.keepRecentTokens
omp config list

omp config set compaction.enabled true
omp config set compaction.strategy context-full
omp config set compaction.thresholdPercent 80
omp config set compaction.thresholdTokens -1
omp config set compaction.reserveTokens 32768
omp config set compaction.keepRecentTokens 30000
omp config set compaction.midTurnEnabled true
omp config set compaction.autoContinue true
``
