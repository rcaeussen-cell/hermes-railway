#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HERMES_HOME"/{sessions,cron,pairing,logs}
mkdir -p /data/workspace

# .env — API keys
{
  echo "DEEPSEEK_API_KEY=${DEEPSEEK_API_KEY}"
  [[ -n "${TELEGRAM_BOT_TOKEN:-}" ]] && echo "TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}"
  [[ -n "${TELEGRAM_ALLOWED_USERS:-}" ]] && echo "TELEGRAM_ALLOWED_USERS=${TELEGRAM_ALLOWED_USERS}"
  echo "HERMES_QUIET=true"
  # WhatsApp
  [[ -n "${WHATSAPP_ENABLED:-}" ]] && echo "WHATSAPP_ENABLED=${WHATSAPP_ENABLED}"
  [[ -n "${WHATSAPP_MODE:-}" ]] && echo "WHATSAPP_MODE=${WHATSAPP_MODE}"
  [[ -n "${WHATSAPP_ALLOWED_USERS:-}" ]] && echo "WHATSAPP_ALLOWED_USERS=${WHATSAPP_ALLOWED_USERS}"
} > "$HERMES_HOME/.env"

# config.yaml
{
  echo "model:"
  echo "  provider: deepseek"
  echo "  default: ${HERMES_MODEL:-deepseek-chat}"
  echo ""
  echo "compression:"
  echo "  enabled: false"
  echo ""
  echo "terminal:"
  echo "  backend: local"
  echo "  cwd: /data/workspace"
  echo ""
  # WhatsApp: silence strangers (recommended for private numbers)
  echo "whatsapp:"
  echo "  unauthorized_dm_behavior: ignore"
} > "$HERMES_HOME/config.yaml"

# SOUL.md — only copy if not already persisted
if [[ ! -f "$HERMES_HOME/SOUL.md" ]]; then
  cp "/SOUL.md" "$HERMES_HOME/SOUL.md"
fi

rm -f "$HERMES_HOME/gateway.pid"
exec hermes gateway
