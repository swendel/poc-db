#!/usr/bin/env bash
set -euo pipefail
# Simple load test using 'hey'
# Env vars (override as needed):
#   BASE_URL - target URL (default: http://localhost:8080/api/start)
#   N        - total number of requests (default: 100)
#   C        - concurrency (default: 5)
#   DETAILS  - value for JSON field 'details' in request body (default: "via hey")
#
# Examples:
#   BASE_URL=http://localhost:8080/api/start N=500 C=10 DETAILS="run A" ./load-hey.sh
#   ./load-hey.sh  # uses defaults

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BASE_URL=${BASE_URL:-http://localhost:8080/api/start}
N=${N:-100}
C=${C:-5}
DETAILS=${DETAILS:-"via hey"}

BODY_FILE="${DIR}/body-hey.json"
echo "{\"details\":\"${DETAILS}\"}" >"${BODY_FILE}"

# Requires: hey (https://github.com/rakyll/hey)
# macOS install: brew install hey
exec hey -n "${N}" -c "${C}" -m POST -H "Content-Type: application/json" -D "${BODY_FILE}" "${BASE_URL}"
