#!/usr/bin/env bash
# Wrapper: write .env from Railway env vars, then run the pre-built image's
# real entrypoint (which is /opt/hermes/docker-entrypoint.sh or similar).

mkdir -p /opt/data

# Write .env
{
  [[ -n "${DEEPSEEK_API_KEY:-}" ]] && echo "DEEPSEEK_API_KEY=${DEEPSEEK_API_KEY}"
  [[ -n "${TELEGRAM_BOT_TOKEN:-}" ]] && echo "TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}"
  [[ -n "${TELEGRAM_ALLOWED_USERS:-}" ]] && echo "TELEGRAM_ALLOWED_USERS=${TELEGRAM_ALLOWED_USERS}"
} > /opt/data/.env

# Run the original entrypoint with the CMD args
exec /opt/hermes/entrypoint.sh "$@"
