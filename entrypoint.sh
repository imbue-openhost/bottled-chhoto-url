#!/bin/sh
set -e
mkdir -p "${OPENHOST_APP_DATA_DIR}/db"
export CHHOTO_DB_URL="${OPENHOST_APP_DATA_DIR}/db/urls.sqlite"
exec "$@"
