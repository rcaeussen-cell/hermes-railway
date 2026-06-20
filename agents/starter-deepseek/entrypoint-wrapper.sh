#!/usr/bin/env bash
# Ensure env vars are exported, then chain to s6 init
export DEEPSEEK_API_KEY 2>/dev/null || true
export TELEGRAM_BOT_TOKEN 2>/dev/null || true
export TELEGRAM_ALLOWED_USERS 2>/dev/null || true
exec /init "$@"
