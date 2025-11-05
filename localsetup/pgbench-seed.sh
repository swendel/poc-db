#!/usr/bin/env bash
# Seed app_db on pg_primary with N rows using pgbench custom script
# Defaults match localsetup/docker-compose.yml
# Usage:
#   ./localsetup/pgbench-seed.sh [COUNT] [CLIENTS]
# Examples:
#   ./localsetup/pgbench-seed.sh            # 1000 rows, 1 client
#   ./localsetup/pgbench-seed.sh 1000 4     # 1000 rows, 4 clients (250 tx/client)

set -euo pipefail

COUNT="${1:-1000}"
CLIENTS="${2:-1}"

HOST="${DB_HOST:-127.0.0.1}"
PORT="${DB_PORT:-55432}"
DBNAME="${DB_NAME:-app_db}"
USER="${DB_USER:-app}"
PASS="${DB_PASSWORD:-app_password}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SQL_FILE="${SCRIPT_DIR}/pgbench-seed.sql"

if ! command -v pgbench >/dev/null 2>&1; then
  echo "Error: pgbench not found. Install via Homebrew (brew install postgresql@16) or use Docker (see README)." >&2
  exit 1
fi

export PGPASSWORD="${PASS}"

# -n: no vacuum; -r: print per-command latencies; -M prepared: use prepared statements
pgbench \
  -h "${HOST}" -p "${PORT}" -U "${USER}" -d "${DBNAME}" \
  -c "${CLIENTS}" -t "${COUNT}" -n -r -M prepared \
  -f "${SQL_FILE}"

echo "\nDone. Inserted ${COUNT} rows into \"BerechnungStatus\" and \"BerechnungDetails\" (one each per transaction)."