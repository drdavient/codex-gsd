FROM node:20-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl bash ca-certificates gosu \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g @openai/codex

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /workspace
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]