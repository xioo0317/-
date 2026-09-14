#!/usr/bin/env bash
# test_api.sh - Test script for local_api server
# Usage: ./test_api.sh [host] [port]
# Default: host=localhost, port=8080

set -euo pipefail

HOST="${1:-127.0.0.1}"
PORT="${2:-8080}"
BASE_URL="http://${HOST}:${PORT}"
EXEC_URL="${BASE_URL}/api/v1/execute"

PASS=0
FAIL=0
TOTAL=0

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

assert_status() {
    local test_name="$1"
    local expected="$2"
    local actual="$3"
    TOTAL=$((TOTAL + 1))
    if [ "$actual" = "$expected" ]; then
        echo -e "  ${GREEN}✓ PASS${NC} ${test_name} (HTTP ${actual})"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗ FAIL${NC} ${test_name} (expected HTTP ${expected}, got ${actual})"
        FAIL=$((FAIL + 1))
    fi
}

echo "==========================================="
echo "  local_api Test Suite (Unified POST API)"
echo "  Target: ${BASE_URL}"
echo "==========================================="
echo ""

# ── Test 1: Health Check ──────────────────────────────
echo "[1/6] Health Check"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "${BASE_URL}/health")
assert_status "GET /health returns 200" "200" "$HTTP_CODE"

BODY=$(curl -s "${BASE_URL}/health")
echo "  Response: ${BODY}"
echo ""

# ── Test 2: list_items action ────────────────────────
echo "[2/6] Action: list_items"
HTTP_CODE=$(curl -s -o /tmp/resp.json -w "%{http_code}" \
    -X POST "${EXEC_URL}" \
    -H "Content-Type: application/json" \
    -d '{"action":"list_items"}')
assert_status "POST /api/v1/execute list_items returns 200" "200" "$HTTP_CODE"

BODY=$(cat /tmp/resp.json)
echo "  Response: ${BODY}"
echo ""

# ── Test 3: create_item action ───────────────────────
echo "[3/6] Action: create_item"
HTTP_CODE=$(curl -s -o /tmp/resp.json -w "%{http_code}" \
    -X POST "${EXEC_URL}" \
    -H "Content-Type: application/json" \
    -d '{"action":"create_item"}')
assert_status "POST /api/v1/execute create_item returns 201" "201" "$HTTP_CODE"

BODY=$(cat /tmp/resp.json)
echo "  Response: ${BODY}"
echo ""

# ── Test 4: update_item action ───────────────────────
echo "[4/6] Action: update_item"
HTTP_CODE=$(curl -s -o /tmp/resp.json -w "%{http_code}" \
    -X POST "${EXEC_URL}" \
    -H "Content-Type: application/json" \
    -d '{"action":"update_item"}')
assert_status "POST /api/v1/execute update_item returns 200" "200" "$HTTP_CODE"

BODY=$(cat /tmp/resp.json)
echo "  Response: ${BODY}"
echo ""

# ── Test 5: delete_item action ───────────────────────
echo "[5/6] Action: delete_item"
HTTP_CODE=$(curl -s -o /tmp/resp.json -w "%{http_code}" \
    -X POST "${EXEC_URL}" \
    -H "Content-Type: application/json" \
    -d '{"action":"delete_item"}')
assert_status "POST /api/v1/execute delete_item returns 200" "200" "$HTTP_CODE"

BODY=$(cat /tmp/resp.json)
echo "  Response: ${BODY}"
echo ""

# ── Test 6: Unknown action ───────────────────────────
echo "[6/6] Unknown action"
HTTP_CODE=$(curl -s -o /tmp/resp.json -w "%{http_code}" \
    -X POST "${EXEC_URL}" \
    -H "Content-Type: application/json" \
    -d '{"action":"foobar"}')
assert_status "POST /api/v1/execute unknown action returns 400" "400" "$HTTP_CODE"

BODY=$(cat /tmp/resp.json)
echo "  Response: ${BODY}"
echo ""

# ── Summary ───────────────────────────────────────────
echo "==========================================="
echo "  Results: ${PASS}/${TOTAL} passed, ${FAIL} failed"
echo "==========================================="

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
exit 0
