FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates git curl && \
    rm -rf /var/lib/apt/lists/*

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Pin to working commit (v0.17.0)
RUN pip install --no-cache-dir \
    "hermes-agent[messaging,cron] @ git+https://github.com/NousResearch/hermes-agent.git@65561e9d"

ENV HERMES_HOME=/data/.hermes
ENV HOME=/data

COPY entrypoint.sh /entrypoint.sh
COPY SOUL.md /SOUL.md
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
