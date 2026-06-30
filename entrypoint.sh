#!/bin/sh
set -e

# Priority: env var (local testing) → secrets service.
if [ -z "${CHHOTO_PASSWORD}" ]; then
    echo "Fetching CHHOTO_PASSWORD from secrets service..."
    CHHOTO_PASSWORD=$(wget -q -O- -T 5 --tries=1 \
        --header "Authorization: Bearer ${OPENHOST_APP_TOKEN}" \
        --header "Content-Type: application/json" \
        --post-data '{"keys":["CHHOTO_PASSWORD"]}' \
        "${OPENHOST_ROUTER_URL}/api/services/v2/call/secrets/get" \
        2>/dev/null | jq -r '.secrets.CHHOTO_PASSWORD // empty') || true
fi

if [ -z "${CHHOTO_PASSWORD}" ]; then
    echo "ERROR: CHHOTO_PASSWORD is not set."
    echo "Add it at https://secrets.${OPENHOST_ZONE_DOMAIN}/ then reload this app."

    BODY="<html><head><title>Setup required</title></head><body>
<h2>Setup required</h2>
<p><strong>CHHOTO_PASSWORD</strong> is not set.</p>
<p>Add it at <a href='https://secrets.${OPENHOST_ZONE_DOMAIN}/'>secrets.${OPENHOST_ZONE_DOMAIN}</a>,
then reload this app from the dashboard.</p>
</body></html>"
    LEN=$(printf '%s' "$BODY" | wc -c)

    while true; do
        printf "HTTP/1.1 503 Service Unavailable\r\nContent-Type: text/html\r\nContent-Length: %d\r\nConnection: close\r\n\r\n%s" \
            "$LEN" "$BODY" | nc -l -p 4567 >/dev/null 2>&1 || true
    done
fi

echo "Password found, starting chhoto-url..."
export CHHOTO_PASSWORD
mkdir -p "${OPENHOST_APP_DATA_DIR}/db"
export CHHOTO_DB_URL="${OPENHOST_APP_DATA_DIR}/db/urls.sqlite"
export CHHOTO_SITE_URL="${CHHOTO_SITE_URL:-https://${OPENHOST_APP_NAME}.${OPENHOST_ZONE_DOMAIN}}"
exec "$@"
