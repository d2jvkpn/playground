#!/bin/bash

. $HOME/.config/claw/settings.env
# CLAW_CONFIG_HOME=$HOME/.local/share/claw
# ANTHROPIC_AUTH_TOKEN=xxxx
# ANTHROPIC_API_KEY=xxxx
# ANTHROPIC_BASE_URL=https://example.com
# OPENAI_BASE_URL="https://api.openai.com/v1"
# OPENAI_API_KEY="sk-..."

exec claw "$@"

exit
# CLAW_CONFIG_HOME=~/.local/share/claw
# settings.json
