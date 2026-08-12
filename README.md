# bottled-chhoto-url

Self-hosted URL shortener using [chhoto-url](https://github.com/SinTan1729/chhoto-url) — a Rust binary, ~6 MB image, <15 MB RAM idle.

## Prerequisites

The **secrets** app must be installed on your Cloud in a Bottle zone. It manages sensitive env vars for other apps.

## Setup

1. Open `https://secrets.<zone-domain>/` and add a secret:
   - Key: `CHHOTO_PASSWORD`
   - Value: your chosen password (you will need this to login)

2. Deploy this app from the Cloud in a Bottle dashboard — when prompted, grant it access to `CHHOTO_PASSWORD`.

`CHHOTO_SITE_URL` and `CHHOTO_DB_URL` are set automatically at startup.

## Deploy / update

```bash
git push
oh app reload links --update --wait --instance <name>
oh app logs links --instance <name>
```

## Local testing

```bash
just serve   # runs on http://localhost:4567, password: local
```

## Upgrade chhoto-url

Change the version tag in `Dockerfile` and redeploy.
