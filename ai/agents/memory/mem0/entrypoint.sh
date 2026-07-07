#!/bin/sh
set -eu

if [ "${REMOVE_APP_PACKAGES:-false}" = "true" ]; then
    rm -rf /app/packages
fi

if [ "${RUN_MIGRATIONS:-true}" = "true" ]; then
    alembic upgrade head
fi

exec "$@"
