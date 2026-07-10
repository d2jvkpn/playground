#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


config="${CLAUDE_CONFIG_DIR:-HOME}/.claude/settings.json"

yq -i -o=json --indent 2 \
  '.env.ANTHROPIC_BASE_URL = "https://api.example.com"' \
  "$config"

yq -i -o=json --indent 2 '
  .env = (.env // {}) |
  .env.CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1" |
  .env.CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY = "1" |
  .env.CLAUDE_CODE_DISABLE_ARTIFACT = "1" |
  .env.ENABLE_CLAUDEAI_MCP_SERVERS = "false" |
  .env.CLAUDE_CODE_MCP_ALLOWLIST_ENV = "1" |
  .env.OTEL_LOG_USER_PROMPTS = "0" |
  .env.OTEL_LOG_ASSISTANT_RESPONSES = "0" |
  .env.OTEL_LOG_TOOL_CONTENT = "0" |
  .env.OTEL_LOG_TOOL_DETAILS = "0" |
  .env.OTEL_METRICS_INCLUDE_ACCOUNT_UUID = "false" |
  .env.OTEL_METRICS_INCLUDE_SESSION_ID = "false" |
  .env.OTEL_METRICS_INCLUDE_RESOURCE_ATTRIBUTES = "false" |
  .env.CLAUDE_CODE_HIDE_CWD = "1"
' "$config"
