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

This allows Codex CLI to authenticate without relying on a `localhost:1455` callback, which does not work reliably inside Docker.

Authentication state is stored in the named Docker volume, so subsequent runs will reuse the session.

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