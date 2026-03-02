FROM node:20-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl bash ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g @openai/codex

# Install GSD integration (Codex skills)
RUN npx -y get-shit-done-cc@latest --codex --global

WORKDIR /workspace
CMD ["bash"]