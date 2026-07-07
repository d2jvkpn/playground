#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
PYTHONPATH=/app python - <<EOF
from auth import hash_password
print(hash_password("NewPassword123!"))
EOF'

API_URL="http://localhost:8888" \
DASHBOARD_URL="http://localhost:3000" \
EMAIL=admin@noreply.me \
PASSWORD="$(python3 -c 'import secrets; print(secrets.token_urlsafe(16))')}" \
NAME="admin" \
OUTPUT="text" \
bash data/mem0ai--mem0.git/server/scripts/seed.sh


EMAIL=<email> PASSWORD=<password> PYTHONPATH=/app python scripts/reset_admin_password.py
