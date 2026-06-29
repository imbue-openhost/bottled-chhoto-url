# yourls

Self-hosted URL shortener using [chhoto-url](https://github.com/SinTan1729/chhoto-url) — a Rust binary, ~6 MB image, <15 MB RAM idle.

## First-time setup

Set the required env vars on your instance before deploying:

```bash
oh app env set CHHOTO_PASSWORD=<your-password> --instance <name>
oh app env set CHHOTO_SITE_URL=https://yourls.<zone-domain> --instance <name>
```

`CHHOTO_DB_URL` is set automatically by `entrypoint.sh` from `OPENHOST_APP_DATA_DIR`.

## Deploy

```bash
git push
oh app reload yourls --update --wait --instance <name>
oh app logs yourls --instance <name>
```

## Upgrade chhoto-url

Change the version tag in `Dockerfile` and redeploy.
