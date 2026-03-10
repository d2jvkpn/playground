---
name: feishu-hook
description: Forward/relay messages to a to a group (by hook_id) when the user explicitly mentions @feishu-hook. Uses yq to read hook_id from a YAML config, then sends a Feishu hook request via the Open Platform API. This mode is useful when you don’t need (or can’t use) an internal app + `open_id` DM, and instead want to post directly into a group via a webhook.
---

# Feishu Hook Forward（Incoming Webhook）
When the user explicitly mentions `@feishu-hook`, forward the remaining text to a **Feishu Group Bot Incoming Webhook**.

## Trigger
- Trigger only when the user clearly indicates forwarding, e.g. message contains `@feishu-hook`.
- Treat the remaining text as the message to post.
- If the user only says `@feishu-hook` with no text, ask what to forward.

## Required config
Store it in config (recommended):
- `~/.openclaw/skills/configs/feishu.yaml`

Example keys (suggested):
- `feishu.hook_id`

## Run the script:
- `scripts/run.sh "<text>"`

## Guardrails
- If webhook returns a non-zero error code, report the full response (`code`, `msg`) for debugging.
- Webhooks post to a **specific group**; they cannot DM arbitrary users.
- If the group bot is configured with security settings (e.g., IP allowlist / signature), you must match those settings or requests will fail.
