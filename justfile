# Build and run locally via podman on http://localhost:4567
# Uses ./local-data/ to simulate OpenHost's app_data volume.
serve:
    mkdir -p ./local-data/db
    podman build -t chhoto-url-local .
    podman run --rm -it \
        -p 4567:4567 \
        -v ./local-data:/app-data \
        -e OPENHOST_APP_DATA_DIR=/app-data \
        -e CHHOTO_PASSWORD=local \
        -e CHHOTO_SITE_URL=http://localhost:4567 \
        chhoto-url-local
