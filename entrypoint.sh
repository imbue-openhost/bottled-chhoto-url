#!/bin/sh
set -e

# Priority: env var (local testing) → secrets service.
if [ -z "${CHHOTO_PASSWORD}" ]; then
    CHHOTO_PASSWORD=$(wget -q -O- \
        --header "Authorization: Bearer ${OPENHOST_APP_TOKEN}" \
        --header "Content-Type: application/json" \
        --post-data '{"keys":["CHHOTO_PASSWORD"]}' \
        "${OPENHOST_ROUTER_URL}/api/services/v2/call/secrets/get" \
        2>/dev/null | jq -r '.secrets.CHHOTO_PASSWORD // empty')
fi

if [ -z "${CHHOTO_PASSWORD}" ]; then
    echo "ERROR: CHHOTO_PASSWORD is not set."
    echo "Add it at https://secrets.${OPENHOST_ZONE_DOMAIN}/ then reload this app."
    exit 1
fi

export CHHOTO_PASSWORD
mkdir -p "${OPENHOST_APP_DATA_DIR}/db"
export CHHOTO_DB_URL="${OPENHOST_APP_DATA_DIR}/db/urls.sqlite"
export CHHOTO_SITE_URL="${CHHOTO_SITE_URL:-https://${OPENHOST_APP_NAME}.${OPENHOST_ZONE_DOMAIN}}"
exec "$@"
