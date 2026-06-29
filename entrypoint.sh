#!/bin/sh
set -e

PASSWORD_FILE="${OPENHOST_APP_DATA_DIR}/password"

# Priority: env var (local testing) → secrets service → persisted generated password.
if [ -z "${CHHOTO_PASSWORD}" ]; then
    CHHOTO_PASSWORD=$(wget -q -O- \
        --header "Authorization: Bearer ${OPENHOST_APP_TOKEN}" \
        --header "Content-Type: application/json" \
        --post-data '{"keys":["CHHOTO_PASSWORD"]}' \
        "${OPENHOST_ROUTER_URL}/api/services/v2/call/secrets/get" \
        2>/dev/null | jq -r '.secrets.CHHOTO_PASSWORD // empty')
fi

if [ -z "${CHHOTO_PASSWORD}" ]; then
    if [ -f "${PASSWORD_FILE}" ]; then
        CHHOTO_PASSWORD=$(cat "${PASSWORD_FILE}")
    else
        mkdir -p "${OPENHOST_APP_DATA_DIR}"
        CHHOTO_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 24)
        echo "${CHHOTO_PASSWORD}" > "${PASSWORD_FILE}"
        chmod 600 "${PASSWORD_FILE}"
        echo "============================================================"
        echo "Generated admin password: ${CHHOTO_PASSWORD}"
        echo "To set a permanent password, add CHHOTO_PASSWORD to:"
        echo "  https://secrets.${OPENHOST_ZONE_DOMAIN}/"
        echo "============================================================"
    fi
fi

export CHHOTO_PASSWORD
mkdir -p "${OPENHOST_APP_DATA_DIR}/db"
export CHHOTO_DB_URL="${OPENHOST_APP_DATA_DIR}/db/urls.sqlite"
export CHHOTO_SITE_URL="${CHHOTO_SITE_URL:-https://${OPENHOST_APP_NAME}.${OPENHOST_ZONE_DOMAIN}}"
exec "$@"
