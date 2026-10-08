# Title
---


#### 1. config
- ./agnets.yaml
- ./models.yaml

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

omp models refresh

omp config set defaultThinkingLevel medium

omp login anthropic
omp login openai-codex

ANTHROPIC_OAUTH_TOKEN=sk-xxx omp

cat > ~/.omp/agent/.env <<'EOF'
ANTHROPIC_OAUTH_TOKEN=sk-xxx
EOF
``

#### 4. usage
```
omp --tools read,grep,find,bash
```
