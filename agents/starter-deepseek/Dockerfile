FROM nousresearch/hermes-agent:v2026.6.19

# Railway volume at /opt/data per pre-built image convention
ENV HERMES_HOME=/opt/data
ENV HOME=/opt/data

# Write .env from Railway env vars before starting gateway
COPY entrypoint-wrapper.sh /entrypoint-wrapper.sh
RUN chmod +x /entrypoint-wrapper.sh

ENTRYPOINT ["/entrypoint-wrapper.sh"]
CMD ["gateway", "run"]
