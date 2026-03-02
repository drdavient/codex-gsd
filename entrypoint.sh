#!/usr/bin/env bash
set -euo pipefail

PUID="${PUID:-1000}"
PGID="${PGID:-1000}"

mkdir -p /codex
chown -R "${PUID}:${PGID}" /codex || true

# Make sure HOME is consistent, many tools still use $HOME/.codex
export HOME=/codex
export CODEX_HOME=/codex

# Optional: keep npm cache writable
export NPM_CONFIG_CACHE=/tmp/npm-cache
mkdir -p "$NPM_CONFIG_CACHE"
chown -R "${PUID}:${PGID}" "$NPM_CONFIG_CACHE" || true

# Install GSD into the active codex home if missing
if [ ! -d /codex/get-shit-done ] && [ ! -f /codex/gsd-file-manifest.json ]; then
  echo "Bootstrapping GSD into /codex"
  gosu "${PUID}:${PGID}" env HOME=/codex CODEX_HOME=/codex \
    npx -y get-shit-done-cc@latest --codex --global
fi

exec gosu "${PUID}:${PGID}" "$@"