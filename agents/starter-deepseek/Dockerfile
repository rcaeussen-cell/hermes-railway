FROM python:3.11-slim

# Node.js v18+ for WhatsApp Baileys bridge
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates git curl gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip install --no-cache-dir \
    "hermes-agent[messaging,cron] @ git+https://github.com/NousResearch/hermes-agent.git"

ENV HERMES_HOME=/data/.hermes
ENV HOME=/data

COPY entrypoint.sh /entrypoint.sh
COPY SOUL.md /SOUL.md
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
