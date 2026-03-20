#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


####
openclaw config --section skills

####
openclaw config set <path> <value>
openclaw config get <path>
openclaw config unset <path>
openclaw config validate

openclaw config set 'skills.entries."some-skill".apiKey' '"sk-xxxx"'

openclaw config get skills.entries --json

####
openclaw config set 'skills.entries."pushover-notify".enabled' true

openclaw config set 'skills.entries."pushover-notify".env' '{"PUSHOVER_APP_TOKEN":"xxx","PUSHOVER_USER_KEY":"yyy"}'

openclaw config set 'skills.entries."pushover-notify".env.PUSHOVER_APP_TOKEN' '"xxx"'
openclaw config set 'skills.entries."pushover-notify".env.PUSHOVER_USER_KEY' '"yyy"'

openclaw config set 'skills.entries."pushover-notify".config.defaultTitle' '"OpenClaw"'
openclaw config set 'skills.entries."pushover-notify".config.defaultPriority' 0

openclaw config get 'skills.entries."pushover-notify"' --json

openclaw config unset 'skills.entries."pushover-notify".env.PUSHOVER_APP_TOKEN'
openclaw config unset 'skills.entries."pushover-notify"'

####
openclaw config set 'skills.entries.pushover-notify' '{
  enabled: true,
  env: {
    PUSHOVER_APP_TOKEN: "xxx",
    PUSHOVER_USER_KEY: "yyy",
    PUSHOVER_DEVICE: "device001"
  },
  config: {
    defaultTitle: "OpenClaw",
    defaultPriority: 0
  }
}'
