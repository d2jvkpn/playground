#!/bin/bash

# mkdir -p data
# echo $CLAUDE_CODE_SESSION_ID > data/last_session_id.txt

id_file="./data/last_session_id.txt"

if [ -s "$id_file" ]; then
    session_id=$(cat "$id_file")
else
    echo "No file: claude_session_id.txt" >&2
    exit 1
fi

claude --resume "$session_id" "$@"
