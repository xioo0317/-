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

# ─ Test 1: list_items action ────────────────────────
echo "[1/5] Action: list_items"
HTTP_CODE=$(curl -s -o /tmp/resp.json -w "%{http_code}" \
    -X POST "${EXEC_URL}" \
    -H "Content-Type: application/json" \
    -d '{"action":"list_items"}')
assert_status "POST /api/v1/execute list_items returns 200" "200" "$HTTP_CODE"

BODY=$(cat /tmp/resp.json)
echo "  Response: ${BODY}"
echo ""

# ── Test 2: create_item action ───────────────────────
echo "[2/5] Action: create_item"
HTTP_CODE=$(curl -s -o /tmp/resp.json -w "%{http_code}" \
    -X POST "${EXEC_URL}" \
    -H "Content-Type: application/json" \
    -d '{"action":"create_item"}')
assert_status "POST /api/v1/execute create_item returns 201" "201" "$HTTP_CODE"

BODY=$(cat /tmp/resp.json)
echo "  Response: ${BODY}"
echo ""

# ── Test 3: update_item action ───────────────────────
echo "[3/5] Action: update_item"
HTTP_CODE=$(curl -s -o /tmp/resp.json -w "%{http_code}" \
    -X POST "${EXEC_URL}" \
    -H "Content-Type: application/json" \
    -d '{"action":"update_item"}')
assert_status "POST /api/v1/execute update_item returns 200" "200" "$HTTP_CODE"

BODY=$(cat /tmp/resp.json)
echo "  Response: ${BODY}"
echo ""

# ─ Test 4: delete_item action ───────────────────────
echo "[4/5] Action: delete_item"
HTTP_CODE=$(curl -s -o /tmp/resp.json -w "%{http_code}" \
    -X POST "${EXEC_URL}" \
    -H "Content-Type: application/json" \
    -d '{"action":"delete_item"}')
assert_status "POST /api/v1/execute delete_item returns 200" "200" "$HTTP_CODE"

BODY=$(cat /tmp/resp.json)
echo "  Response: ${BODY}"
echo ""

# ── Test 5: Unknown action ──────────────────────────
echo "[5/5] Unknown action"
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
