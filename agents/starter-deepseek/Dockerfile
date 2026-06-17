FROM python:3.11-slim

# Node.js v20+ for WhatsApp Baileys bridge
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates git curl gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip install --no-cache-dir \
    "hermes-agent[messaging,cron] @ git+https://github.com/NousResearch/hermes-agent.git"

# Install WhatsApp Baileys bridge dependencies
RUN npm install --prefix /opt/venv/lib/python3.11/site-packages/scripts/whatsapp-bridge \
    --no-fund --no-audit --progress=false

ENV HERMES_HOME=/data/.hermes
ENV HOME=/data

COPY entrypoint.sh /entrypoint.sh
COPY SOUL.md /SOUL.md
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
