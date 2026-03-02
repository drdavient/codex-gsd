# Codex + GSD Docker Runtime

This repository provides a minimal Docker runtime for:

- OpenAI Codex CLI
- get-shit-done (GSD)
- Mounting a Logseq vault as a working directory

It contains no application logic
Its sole purpose is to provide a reproducible Codex + GSD execution environment.

---

## What This Repo Contains

- `Dockerfile`
- `docker-compose.yml`
- `.env` (local only, not committed)

It does not contain your Logseq vault.

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
```

Do not commit this file.

---

## Build

```
docker compose build
```

---

## First Run: Web Authentication

```
docker compose run --rm codex
```

Inside the container:

```
codex auth login
```

Open the provided URL in your host browser and complete authentication.

Authentication state is persisted via a named Docker volume.

---

## Start Codex

```
docker compose run --rm codex
```

Inside the container:

```
codex
```

The working directory is your mounted Logseq vault.

---

## GSD

GSD is preinstalled for Codex.

Inside Codex, you may use:

```
gsd-help
```

GSD extends Codex behaviour and uses the same authentication session.

---


---

## Removal

To remove persisted Codex authentication:

```
docker volume rm codex-gsd_codex-home
```