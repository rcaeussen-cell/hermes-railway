#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HERMES_HOME"/{sessions,cron,pairing,logs}

{
  echo "OPENAI_API_KEY=${OPENAI_API_KEY:-}"
  echo "GOOGLE_API_KEY=${GOOGLE_API_KEY:-}"
  echo "ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY:-}"
  echo "TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}"
  [[ -n "${TELEGRAM_ALLOWED_USERS:-}" ]] && echo "TELEGRAM_ALLOWED_USERS=${TELEGRAM_ALLOWED_USERS}"
  echo "HERMES_QUIET=true"
} > "$HERMES_HOME/.env"

{
  echo "model:"
  echo "  provider: ${HERMES_PROVIDER}"
  echo "  default: ${HERMES_MODEL}"
  echo "compression:"
  echo "  enabled: false"
  echo "terminal:"
  echo "  backend: local"
  echo "  cwd: /data/workspace"
} > "$HERMES_HOME/config.yaml"

# Copy agent SOUL.md on first boot only
AGENT_DIR="/agents/${AGENT_NAME}"
if [[ ! -f "$HERMES_HOME/SOUL.md" ]] && [[ -f "$AGENT_DIR/SOUL.md" ]]; then
  cp "$AGENT_DIR/SOUL.md" "$HERMES_HOME/SOUL.md"
fi

rm -f "$HERMES_HOME/gateway.pid"
exec hermes gateway
