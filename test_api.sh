#!/usr/bin/env bash
# test_api.sh - Test script for local_api server
# Usage: ./test_api.sh [host] [port]
# Default: host=localhost, port=8080

set -euo pipefail

HOST="${1:-127.0.0.1}"
PORT="${2:-8080}"
BASE_URL="http://${HOST}:${PORT}"
API_URL="${BASE_URL}/api/v1/items"

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
echo "  local_api Test Suite"
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

# ── Test 2: List Items (initial) ──────────────────────
echo "[2/6] List Items (empty)"
HTTP_CODE=$(curl -s -o /tmp/resp.json -w "%{http_code}" "${API_URL}")
assert_status "GET /api/v1/items returns 200" "200" "$HTTP_CODE"

BODY=$(cat /tmp/resp.json)
echo "  Response: ${BODY}"
echo ""

# ── Test 3: Create Item ──────────────────────────────
echo "[3/6] Create Item"
HTTP_CODE=$(curl -s -o /tmp/resp.json -w "%{http_code}" \
    -X POST "${API_URL}" \
    -H "Content-Type: application/json" \
    -d '{"name": "test_item", "value": 42}')
assert_status "POST /api/v1/items returns 201" "201" "$HTTP_CODE"

BODY=$(cat /tmp/resp.json)
echo "  Response: ${BODY}"
echo ""

# ── Test 4: Update Item ──────────────────────────────
echo "[4/6] Update Item (id=1)"
HTTP_CODE=$(curl -s -o /tmp/resp.json -w "%{http_code}" \
    -X PUT "${API_URL}/1" \
    -H "Content-Type: application/json" \
    -d '{"name": "updated_item", "value": 99}')
assert_status "PUT /api/v1/items/1 returns 200" "200" "$HTTP_CODE"

BODY=$(cat /tmp/resp.json)
echo "  Response: ${BODY}"
echo ""

# ── Test 5: Delete Item ──────────────────────────────
echo "[5/6] Delete Item (id=1)"
HTTP_CODE=$(curl -s -o /tmp/resp.json -w "%{http_code}" \
    -X DELETE "${API_URL}/1")
assert_status "DELETE /api/v1/items/1 returns 200" "200" "$HTTP_CODE"

BODY=$(cat /tmp/resp.json)
echo "  Response: ${BODY}"
echo ""

# ── Test 6: 404 Handler ──────────────────────────────
echo "[6/6] 404 Handler"
HTTP_CODE=$(curl -s -o /tmp/resp.json -w "%{http_code}" "${BASE_URL}/nonexistent")
assert_status "GET /nonexistent returns 404" "404" "$HTTP_CODE"

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
