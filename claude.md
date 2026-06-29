- read README.md at the beginning of every session.
- this is an OpenHost app. `openhost.toml` is the app manifest.
- the app is chhoto-url (Rust URL shortener). the Dockerfile pulls `ghcr.io/sintan1729/chhoto-url:7.2.4-alpine` — there is no source code to edit. to upgrade, change the version tag in `Dockerfile`.
- `entrypoint.sh` sets `CHHOTO_DB_URL` from `OPENHOST_APP_DATA_DIR` at container startup and execs the chhoto-url binary.
- instance-specific env vars (`CHHOTO_PASSWORD`, `CHHOTO_SITE_URL`) must be set via `oh app env set` — they are secrets and not in this repo.

## deploying & debugging on openhost

- openhost is a cloud platform for self-hosting apps. there's context on openhost at `~/work/openhost`; read `docs/src/creating_an_app.md` there for how apps are built and run.
- instances are managed via the `oh` cli. `oh instance list` shows the configured instances and the URL each is available at. the user will tell you which instance to use; do not touch the others. most commands take `--instance <name>`.
- these instances have web servers facing the public internet. be careful with anything that could open unsecured public access — eg adding `public_paths` in `openhost.toml`.
- prefer `oh` commands for debugging since they handle auth: `oh instance ssh` and `oh curl`. `oh instance token --instance <name>` gives a raw API token (Bearer auth) only if absolutely necessary — better not to see it, and never put it anywhere that might get committed.
- typical deploy loop: commit + push, then `oh app reload <app> --update --wait --instance <name>` to pull the changes and reload, then `oh app logs <app> --instance <name>` to check the logs.
- to test pages in a browser as the user would see them, use playwright and inject the API token as a Bearer header — this matches a request made with the owner's login cookies.
