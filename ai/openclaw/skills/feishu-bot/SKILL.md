---
name: feishu-bot
description: Forward/relay messages to a specific Feishu user (by open_id) when the user explicitly mentions @feishu-bot (or asks to “转发给飞书/发给某个 open_id”). Uses yq to read open_id and app credentials from a YAML config, then sends a Feishu DM via the Open Platform API.
---

# Feishu Robot Forward
Forward the content after an explicit bot mention (e.g. “@feishu-bot 你好 …”) to a configured Feishu user (open_id).

## Workflow
1) **Detect intent**
- Trigger only when the user clearly indicates forwarding, e.g. message contains `@feishu-bot`.
- Treat the remaining text as the message to forward.

2) **Read config (via yq)**
- Config must contain:
  - `feishu.app_id`
  - `feishu.app_secret`
  - `feishu.target_open_id`
- Example config: `references/config.example.yaml`
- Location: `~/.openclaw/skills/configs/feishu.yaml`

3) **Send DM**
- Run the script:
  - `scripts/run.sh "<text>"`
- Script flow:
  - fetch `tenant_access_token` (internal app)
  - send `im/v1/messages` with `receive_id_type=open_id`

## Notes / Guardrails
- Do not forward silently: confirm success (message_id) or report Feishu error code/msg.
- If the user only says “@feishu-bot” with no text, ask what to forward.
- If Feishu returns `230013 (Bot has NO availability to this user)`, explain it means the bot cannot proactively DM that user (visibility / app scope / no session).
