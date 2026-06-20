#!/usr/bin/env bash
set -euo pipefail

# Fix permissions for Railway volume (pre-built image runs as non-root)
mkdir -p "$HERMES_HOME"/{sessions,cron,pairing,logs} 2>/dev/null || true
# Ensure write access for the hermes user
chmod -R 777 "$HERMES_HOME" 2>/dev/null || true
mkdir -p /data/workspace
chmod 777 /data/workspace 2>/dev/null || true

# .env — API keys
# WhatsApp is skipped on first run (no session yet).
# After pairing via 'hermes whatsapp', set WHATSAPP_ENABLED=true in Railway vars.
WHATSAPP_SESSION="$HERMES_HOME/whatsapp/session/creds.json"
WHATSAPP_READY=false
if [[ "${WHATSAPP_ENABLED:-}" == "true" ]] && [[ -f "$WHATSAPP_SESSION" ]]; then
  WHATSAPP_READY=true
fi

# Force-disable WhatsApp if not paired — Railway env vars would
# otherwise override and crash the gateway.
if ! $WHATSAPP_READY; then
  export WHATSAPP_ENABLED=false
fi

{
  echo "DEEPSEEK_API_KEY=${DEEPSEEK_API_KEY}"
  [[ -n "${TELEGRAM_BOT_TOKEN:-}" ]] && echo "TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}"
  [[ -n "${TELEGRAM_ALLOWED_USERS:-}" ]] && echo "TELEGRAM_ALLOWED_USERS=${TELEGRAM_ALLOWED_USERS}"
  echo "HERMES_QUIET=true"
  if $WHATSAPP_READY; then
    echo "WHATSAPP_ENABLED=true"
    echo "WHATSAPP_MODE=${WHATSAPP_MODE:-self-chat}"
    [[ -n "${WHATSAPP_ALLOWED_USERS:-}" ]] && echo "WHATSAPP_ALLOWED_USERS=${WHATSAPP_ALLOWED_USERS}"
  fi
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
} > "$HERMES_HOME/config.yaml"

# SOUL.md — only copy if not already persisted
if [[ ! -f "$HERMES_HOME/SOUL.md" ]]; then
  cp "/SOUL.md" "$HERMES_HOME/SOUL.md"
fi

if [[ "${WHATSAPP_ENABLED:-}" == "true" ]] && [[ ! -f "$WHATSAPP_SESSION" ]]; then
  echo ""
  echo "╔══════════════════════════════════════════════════════════════╗"
  echo "║  📱 WhatsApp ingeschakeld maar nog NIET gekoppeld           ║"
  echo "║                                                              ║"
  echo "║  Open Railway web terminal en run:                           ║"
  echo "║    hermes whatsapp                                           ║"
  echo "║                                                              ║"
  echo "║  Scan de QR code met WhatsApp op je telefoon.                ║"
  echo "║  Daarna herstart de service.                                 ║"
  echo "╚══════════════════════════════════════════════════════════════╝"
  echo ""
fi

rm -f "$HERMES_HOME/gateway.pid"
exec hermes gateway
