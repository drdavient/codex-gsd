#!/usr/bin/env bash
set -euo pipefail

PUID="${PUID:-1000}"
PGID="${PGID:-1000}"

# Ensure CODEX_HOME exists and is writable
mkdir -p /codex
chown -R "${PUID}:${PGID}" /codex || true

# Make npm cache writable regardless of what HOME ends up being
export HOME=/tmp/home
mkdir -p "$HOME"
chown -R "${PUID}:${PGID}" "$HOME" || true
export NPM_CONFIG_CACHE=/tmp/npm-cache
mkdir -p "$NPM_CONFIG_CACHE"
chown -R "${PUID}:${PGID}" "$NPM_CONFIG_CACHE" || true

# Install GSD into CODEX_HOME if skills are missing/empty
if [ ! -d /codex/skills ] || [ -z "$(ls -A /codex/skills 2>/dev/null || true)" ]; then
  echo "Bootstrapping GSD into CODEX_HOME=/codex"
  gosu "${PUID}:${PGID}" env CODEX_HOME=/codex \
    npx -y get-shit-done-cc@latest --codex --global
fi

# Drop privileges for the actual command
exec gosu "${PUID}:${PGID}" "$@"