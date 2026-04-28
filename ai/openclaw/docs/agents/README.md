# OpenClaw: Agents
---
```meta

```
---


#### ch01. commands
- openclaw agents list
- openclaw agents add agent01 \
  --workspace ~/.openclaw/agent01 \
  --agent-dir ~/.openclaw/agents/agent01 \
  --model qwen3.5-plus
  # --bind [feishu | feishu:account]
- openclaw agents set-identity --agent agent01 --name "agent01" --emoji 🤖
- openclaw agents bindings
- openclaw tui --agent agent01
- openclaw agent --agent agent01 --message "测试" --deliver
- openclaw agents bind --agent agent01 --bind telegram:supportbot
- openclaw agents delete agent01

#### ch02. Agent to Agent
1. settings
```
{
  "tools": {
    "agentToAgent": {
      "enabled": true,
      "allow": ["main", "youtube", "writer", "cpo", "coo"]
    }
  },
  "memorySearch": {
    "enabled": true,
    "provider": "local"
  }
}
```

2. AGENTS.md
```
## Post-Approval Distribution
- Notify Writer + Motus via session_send:
- Video title
- Path to approved script
- Key talking points
- Post to #agents-comms for visibility
```

#### ch03. Subagents
1. settings
```
{
  "maxConcurrent": 4,
  "subagents": {
    "maxConcurrent": 8
  }
}
```

2. AGENTS.md
```
我帮你整理+校正了一下 OCR 结果（去掉识别错误、统一格式），这是干净版👇

---

## Subagent Delegation

* Spawn subagents for: animation renders, voiceover generation, video editing
* Always include full context in the `task` param (subagents can't see SOUL.md or MEMORY.md)
* Use descriptive `label`: "render-scene-1", "voiceover-draft-3"
* Set `runTimeoutSeconds`: renders=300, voiceover=180, research=120
* Don't poll subagents in a loop — announces are push-based

---

## Parallel Production (USE THIS for multi-scene videos)

Instead of rendering everything sequentially (which loses context), decompose:

```
Step 1 — Plan: break video into independent scenes

Step 2 — Spawn parallel:
→ spawn "render-scene-1" (include: design.py path, script segment, scene spec)
→ spawn "render-scene-2" (same context pattern)
→ spawn "voiceover-full" (include: full script text, voice settings)

Step 3 — Wait: announces come back automatically with output paths

Step 4 — Spawn assembly:
→ spawn "assembly-final" (include: all output paths from announces, concat order)

Step 5 — Quality check the final output, deliver to Jing
```
