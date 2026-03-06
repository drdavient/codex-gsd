#!/usr/bin/env bash
# entrypoint.sh
set -euo pipefail

PUID="${PUID:-1000}"
PGID="${PGID:-1000}"

CODEX_HOME="${CODEX_HOME:-/codex}"
HOME_DIR="${HOME:-/codex}"

mkdir -p "${CODEX_HOME}"
chown -R "${PUID}:${PGID}" "${CODEX_HOME}" || true

CONFIG_FILE="${CODEX_HOME}/config.toml"

# Create Codex config on first run (volume starts empty)
if [ ! -f "${CONFIG_FILE}" ]; then
  cat <<EOF > "${CONFIG_FILE}"
approval_policy = "never"
sandbox_mode = "workspace-write"

[sandbox_workspace_write]
network_access = true
EOF
  chown "${PUID}:${PGID}" "${CONFIG_FILE}" || true
fi

# Install GSD into CODEX_HOME on first run
if [ ! -f "${CODEX_HOME}/gsd-file-manifest.json" ]; then
  echo "Bootstrapping GSD into ${CODEX_HOME}"
  gosu "${PUID}:${PGID}" env HOME="${HOME_DIR}" CODEX_HOME="${CODEX_HOME}" \
    npx -y get-shit-done-cc@latest --codex --global
fi

exec gosu "${PUID}:${PGID}" "$@"