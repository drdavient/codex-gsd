#!/usr/bin/env bash
set -euo pipefail

PUID="${PUID:-1000}"
PGID="${PGID:-1000}"

mkdir -p /codex
chown -R "${PUID}:${PGID}" /codex || true

# Drop privileges for everything after this point
exec gosu "${PUID}:${PGID}" "$@"
