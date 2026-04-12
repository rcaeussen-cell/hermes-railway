#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HERMES_HOME"/{sessions,cron,pairing,logs}

{
  echo "ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}"
  echo "TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}"
  [[ -n "${TELEGRAM_ALLOWED_USERS:-}" ]] && echo "TELEGRAM_ALLOWED_USERS=${TELEGRAM_ALLOWED_USERS}"
  echo "HERMES_QUIET=true"
} > "$HERMES_HOME/.env"

{
  echo "model:"
  echo "  provider: anthropic"
  echo "  default: ${HERMES_MODEL}"
  echo ""
  echo "compression:"
  echo "  enabled: false"
  echo ""
  echo "terminal:"
  echo "  backend: local"
  echo "  cwd: /data/workspace"
} > "$HERMES_HOME/config.yaml"

if [[ ! -f "$HERMES_HOME/SOUL.md" ]]; then
  cp "/agents/starter-anthropic/SOUL.md" "$HERMES_HOME/SOUL.md"
fi

rm -f "$HERMES_HOME/gateway.pid"
exec hermes gateway
