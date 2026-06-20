FROM nousresearch/hermes-agent:v2026.6.19

ENV HERMES_HOME=/data/.hermes
ENV HOME=/data

COPY entrypoint.sh /entrypoint.sh
COPY SOUL.md /SOUL.md
RUN chmod +x /entrypoint.sh

USER root
CMD ["/entrypoint.sh"]
