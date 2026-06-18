FROM python:3.11-slim

# Node.js v20+ for WhatsApp Baileys bridge
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates git curl gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Hermes via pip (the core + messaging)
RUN pip install --no-cache-dir \
    "hermes-agent[messaging,cron] @ git+https://github.com/NousResearch/hermes-agent.git"

# The WhatsApp bridge lives in scripts/whatsapp-bridge/ in the git repo,
# but pip install doesn't package it. Clone a shallow copy to get it.
RUN git clone --depth 1 https://github.com/NousResearch/hermes-agent.git /tmp/hermes-src && \
    mkdir -p /opt/venv/lib/python3.11/site-packages/scripts && \
    cp -r /tmp/hermes-src/scripts/whatsapp-bridge /opt/venv/lib/python3.11/site-packages/scripts/whatsapp-bridge && \
    rm -rf /tmp/hermes-src

# Install WhatsApp bridge npm dependencies
RUN npm install --prefix /opt/venv/lib/python3.11/site-packages/scripts/whatsapp-bridge \
    --no-fund --no-audit --progress=false

ENV HERMES_HOME=/data/.hermes
ENV HOME=/data

COPY entrypoint.sh /entrypoint.sh
COPY SOUL.md /SOUL.md
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
