#!/usr/bin/env bash
set -euo pipefail

PUID="${PUID:-1000}"
PGID="${PGID:-1000}"

# Ensure Codex home exists
mkdir -p /codex
chown -R "${PUID}:${PGID}" /codex || true

# Align HOME and CODEX_HOME
export HOME=/codex
export CODEX_HOME=/codex

# Ensure npm cache is writable
export NPM_CONFIG_CACHE=/tmp/npm-cache
mkdir -p "$NPM_CONFIG_CACHE"
chown -R "${PUID}:${PGID}" "$NPM_CONFIG_CACHE" || true

# Create Codex config if it doesn't exist
CONFIG_FILE="/codex/config.toml"

if [ ! -f "$CONFIG_FILE" ]; then
cat <<EOF > "$CONFIG_FILE"
approval_mode = "never"
sandbox_mode = "workspace-write"

[sandbox_workspace_write]
network_access = true
EOF
fi

# Bootstrap GSD if not already installed
if [ ! -f "/codex/gsd-file-manifest.json" ]; then
  echo "Bootstrapping GSD into /codex"
  gosu "${PUID}:${PGID}" env HOME=/codex CODEX_HOME=/codex \
    npx -y get-shit-done-cc@latest --codex --global
fi

# Drop privileges and run the requested command
exec gosu "${PUID}:${PGID}" "$@"