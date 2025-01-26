#!/usr/bin/env bash

if [ -p /dev/stdin ]; then
CONTEXT=$(</dev/stdin)
fi

QUERY=$*
PROMPT="${QUERY}\n$CONTEXT"
OLLAMA_URL=${OLLAMA_URL:-http://localhost:11434}

PROMPT="$(echo "$PROMPT" | jaq -Rs)"

CURL_DATA='{
    "model": "shell-helper:latest",
    "stream": false,
    "prompt": '$PROMPT'
}';

# echo "$CURL_DATA"

curl -s "${OLLAMA_URL}/api/generate" \
    --data "$CURL_DATA" | \
    jaq -r '.response' | xargs -0 printf "%b"
