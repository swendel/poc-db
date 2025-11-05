#!/usr/bin/env bash
# Seed app_db on pg_primary with N rows using pgbench (via Docker)
# Defaults match localsetup/docker-compose.yml
# Usage:
#   ./localsetup/pgbench-seed.sh [COUNT] [CLIENTS]
# Examples:
#   ./localsetup/pgbench-seed.sh            # 1000 rows, 1 client
#   ./localsetup/pgbench-seed.sh 1000 4     # 1000 rows, 4 clients (250 tx/client)
#
# This script runs pgbench inside a short-lived Docker container (postgres image).
# It does NOT require a local pgbench installation.

set -euo pipefail

COUNT="${1:-10}"
CLIENTS="${2:-1}"

# When pgbench runs inside Docker, use host.docker.internal by default to reach the DB
HOST="${DB_HOST:-host.docker.internal}"
PORT="${DB_PORT:-55432}"
DBNAME="${DB_NAME:-app_db}"
USER="${DB_USER:-app}"
PASS="${DB_PASSWORD:-app_password}"

# Docker image to use for pgbench; override with PGBENCH_IMAGE if needed
IMAGE="${PGBENCH_IMAGE:-postgres:16}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SQL_FILE="${SCRIPT_DIR}/pgbench-seed.sql"

if command -v docker >/dev/null 2>&1; then
  # Use Dockerized pgbench
  docker run --rm \
    -e PGPASSWORD="${PASS}" \
    -v "${SQL_FILE}:/work/pgbench-seed.sql:ro" \
    "${IMAGE}" \
    pgbench \
      -h "${HOST}" -p "${PORT}" -U "${USER}" -d "${DBNAME}" \
      -c "${CLIENTS}" -t "${COUNT}" -n -r -M simple \
      -f /work/pgbench-seed.sql
else
  # Fallback: try local pgbench if Docker is not available
  if command -v pgbench >/dev/null 2>&1; then
    export PGPASSWORD="${PASS}"
    pgbench \
      -h "${HOST}" -p "${PORT}" -U "${USER}" -d "${DBNAME}" \
      -c "${CLIENTS}" -t "${COUNT}" -n -r -M simple \
      -f "${SQL_FILE}"
  else
    echo "Error: Neither Docker nor local pgbench is available.\n" \
         "Install Docker (https://docs.docker.com/get-docker/) or pgbench (e.g., brew install postgresql@16)." >&2
    exit 1
  fi
fi

echo "\nDone. Inserted ${COUNT} rows into \"BerechnungStatus\" and \"BerechnungDetails\" (one each per transaction)."