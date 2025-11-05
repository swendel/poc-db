#!/usr/bin/env bash
# Befülle app_db auf pg_primary mit N Zeilen per pgbench (via Docker)
# Defaults entsprechen localsetup/docker-compose.yml
# Nutzung:
#   ./localsetup/pgbench-seed.sh [ANZAHL] [CLIENTS]
# Beispiele:
#   ./localsetup/pgbench-seed.sh            # 1000 Zeilen, 1 Client
#   ./localsetup/pgbench-seed.sh 1000 4     # 1000 Zeilen, 4 Clients (250 Tx/Client)
#
# Dieses Skript startet pgbench in einem kurzlebigen Docker-Container (postgres-Image).
# Eine lokale pgbench-Installation ist NICHT erforderlich.

set -euo pipefail

COUNT="${1:-10000}"
CLIENTS="${2:-1}"

# Wenn pgbench in Docker läuft, standardmäßig host.docker.internal verwenden, um die DB zu erreichen
HOST="${DB_HOST:-host.docker.internal}"
PORT="${DB_PORT:-55432}"
DBNAME="${DB_NAME:-app_db}"
USER="${DB_USER:-app}"
PASS="${DB_PASSWORD:-app_password}"

# Docker-Image für pgbench; bei Bedarf mit PGBENCH_IMAGE überschreiben
IMAGE="${PGBENCH_IMAGE:-postgres:16}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SQL_FILE="${SCRIPT_DIR}/pgbench-seed.sql"

if command -v docker >/dev/null 2>&1; then
  # Verwendung von Dockerisiertem pgbench (Docker erforderlich)
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