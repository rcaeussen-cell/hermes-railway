#!/usr/bin/env bash
# Write .env from Railway env vars, then chain to s6 init
mkdir -p /opt/data
{
  [[ -n "${DEEPSEEK_API_KEY:-}" ]] && echo "DEEPSEEK_API_KEY=${DEEP..."
  [[ -n "${TELEGRAM_BOT_TOKEN:-}" ]] && echo "TELEGRAM_BOT_TOKEN=${TELE..."
  [[ -n "${TELEGRAM_ALLOWED_USERS:-}" ]] && echo "TELEGRAM_ALLOWED_USERS=${TELEGRAM_ALLOWED_USERS}"
} > /opt/data/.env

exec /init "$@"
