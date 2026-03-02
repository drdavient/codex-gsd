# Codex + GSD Docker Runtime

This repository provides a minimal Docker runtime for:

- OpenAI Codex CLI
- get-shit-done (GSD)
- Mounting a Logseq vault as a working directory

It contains no application logic.
Its sole purpose is to provide a reproducible Codex + GSD execution environment.

---

## What This Repo Contains

- `Dockerfile`
- `docker-compose.yml`
- `.env` (local only, not committed)

It does not contain your Logseq vault.

---

## Architecture

The container:

- Runs as your host UID/GID to avoid permission issues
- Mounts your Logseq vault at `/workspace`
- Stores Codex state in a Docker named volume mounted at `/codex`
- Uses `CODEX_HOME=/codex` so runtime user and home directory never conflict

This avoids permission mismatches and makes the setup portable across machines.

---

## Prerequisites

- Docker
- Docker Compose
- A local Logseq vault directory

---

## Configuration

Create a `.env` file:

```
LOGSEQ_VAULT_PATH=/absolute/path/to/your/logseq/vault
UID=1000
GID=1000
COMPOSE_PROJECT_NAME=codex-gsd
```

Set `UID` and `GID` to match your host user:

```
id -u
id -g
```

Do not commit this file.

---

## Build

```
docker compose build
```

---

## First Run: Device Authentication

Instead of relying on the default OAuth callback, which often fails inside containers, use device code authentication.

Run:

```
docker compose run --rm codex
```

Inside the container:

### Device Code Login

```
codex login --device-auth
```

This prints:

- A URL to open in your browser
- A one-time code to paste

Visit the URL in your host browser, paste the code, and complete the login.

**Important:** In your ChatGPT account settings, you may need to:

- Enable multi-factor authentication (2FA)
- Enable Device Code Authorisation for Codex if your workspace restricts device-code flows

Authentication state is stored in the `codex-state` Docker volume, so subsequent runs will reuse the session.

---

## Start Codex

```
docker compose run --rm codex
```

Inside the container:

```
codex -- --approval-mode=never
```

The extra `--` ensures the approval flag is forwarded correctly.

Using `--approval-mode=never` allows Codex and GSD to execute Bash, Git, and other actions without interactive confirmation.

The working directory is your mounted Logseq vault.

---

## GSD

GSD is preinstalled for Codex.

Inside Codex, you may use:

```
gsd-help
```

GSD extends Codex behaviour and uses the same authentication session.

GSD stores planning state in a `.planning/` directory in the project root.

---

## Safety Model

Codex runs inside Docker.

It can modify anything under `/workspace` (your mounted vault).
It cannot modify your wider system unless you mount additional host paths.

Recommended safeguards:

- Keep your vault under Git
- Commit before running autonomous workflows
- Do not mount your home directory or Docker socket
- Mount only what you are willing to let the agent modify

---

## Volumes

- `/workspace` → your Logseq vault (bind mount)
- `/codex` → Docker named volume for Codex state

Inspect volumes:

```
docker volume ls
docker volume inspect codex-state
```

---

## Removal

To remove persisted Codex authentication and state:

```
docker compose down -v
```

This removes the `codex-state` volume.