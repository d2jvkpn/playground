#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit

openclaw agents add chatgpt \
  --workspace ~/.openclaw/agents/chatgpt/worksapce \
  --model openai/gpt-5.5 \
  --non-interactive

#openclaw agents bind --agent <agent-id> --bind <channel[:accountId]>
openclaw agents bind --agent chatgpt --bind mattermost:chatgpt

openclaw agents list --bindings
