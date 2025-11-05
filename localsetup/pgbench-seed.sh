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

COUNT="${1:-10000}"
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
  # Use Dockerized pgbench (Docker required)
  docker run --rm \
    -e PGPASSWORD="${PASS}" \
    -v "${SQL_FILE}:/work/pgbench-seed.sql:ro" \
    "${IMAGE}" \
    pgbench \
      -h "${HOST}" -p "${PORT}" -U "${USER}" -d "${DBNAME}" \
      -c "${CLIENTS}" -t "${COUNT}" -n -r -M simple \
      -f /work/pgbench-seed.sql
else
  echo "Error: Docker is required to run this script. Please install Docker and ensure the 'docker' CLI is available in PATH." >&2
  exit 1
fi

echo "\nDone. Inserted ${COUNT} rows into \"BerechnungStatus\" and \"BerechnungDetails\" (one each per transaction)."