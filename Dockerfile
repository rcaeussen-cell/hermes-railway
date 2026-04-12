FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates git && rm -rf /var/lib/apt/lists/*

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip install --no-cache-dir \
    "hermes-agent[messaging,cron] @ git+https://github.com/NousResearch/hermes-agent.git"

ENV HERMES_HOME=/data/.hermes
ENV HOME=/data

COPY agents/ /agents/
RUN find /agents -name "entrypoint.sh" -exec chmod +x {} \;

CMD ["/bin/bash", "-c", "/agents/${AGENT_NAME}/entrypoint.sh"]
