#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HERMES_HOME"/{sessions,cron,pairing,logs}
mkdir -p /data/workspace

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
  [[ -n "${IG_USER_ID:-}" ]] && echo "IG_USER_ID=${IG_USER_ID}"
  [[ -n "${INSTAGRAM_ACCESS_TOKEN:-}" ]] && echo "INSTAGRAM_ACCESS_TOKEN=${INSTAGRAM_ACCESS_TOKEN}"
  [[ -n "${IMGBB_API_KEY:-}" ]] && echo "IMGBB_API_KEY=${IMGBB_API_KEY}"
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

# SOUL.md — always update from image
cp "/SOUL.md" "$HERMES_HOME/SOUL.md"

# Data files — copy from image to persistent volume on first deploy
if [[ ! -f /data/jaarplanning-2026-calamiteiten.xlsx ]]; then
  cp /data-files/jaarplanning-2026-calamiteiten.xlsx /data/jaarplanning-2026-calamiteiten.xlsx
  echo "✓ Jaarplanning gekopieerd naar /data/"
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
