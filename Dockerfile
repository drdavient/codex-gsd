# Dockerfile
FROM node:20-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl bash ca-certificates gosu \
    ripgrep fd-find jq less tree procps unzip micro \
  && ln -sf /usr/bin/fdfind /usr/local/bin/fd \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g @openai/codex

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /workspace
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]