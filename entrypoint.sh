#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HERMES_HOME"/{sessions,cron,pairing,logs}

# Write .env — secrets only
{
  [[ -n "${GOOGLE_API_KEY:-}" ]]    && echo "GOOGLE_API_KEY=${GOOGLE_API_KEY}"
  [[ -n "${ANTHROPIC_API_KEY:-}" ]] && echo "ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}"
  [[ -n "${TELEGRAM_ALLOWED_USERS:-}" ]] && echo "TELEGRAM_ALLOWED_USERS=${TELEGRAM_ALLOWED_USERS}"
  echo "TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}"
  echo "HERMES_QUIET=true"
} > "$HERMES_HOME/.env"

# Write config.yaml
{
  echo "model:"
  if [[ "${HERMES_PROVIDER}" == "openai" ]]; then
    echo "  provider: custom"
    echo "  default: ${HERMES_MODEL}"
    echo ""
    echo "custom_providers:"
    echo "  - name: main"
    echo "    base_url: https://api.openai.com/v1"
    echo "    api_key: ${OPENAI_API_KEY}"
  else
    echo "  provider: ${HERMES_PROVIDER}"
    echo "  default: ${HERMES_MODEL}"
  fi
  echo ""
  echo "compression:"
  echo "  enabled: false"
  echo ""
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
