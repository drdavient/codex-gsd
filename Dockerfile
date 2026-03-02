FROM node:20-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl bash ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Install Codex CLI
RUN npm install -g @openai/codex

# Create non-root user
RUN useradd -ms /bin/bash codex
USER codex
WORKDIR /home/codex

# Install get-shit-done for Codex
RUN npx -y get-shit-done-cc@latest --codex --global

WORKDIR /workspace

CMD ["bash"]