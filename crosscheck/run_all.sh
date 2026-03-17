#!/usr/bin/env bash
# run_all.sh — snobol4x crosscheck harness
#
# Runs every .sno file through sno2c, compiles the C, runs the binary,
# diffs output against the .ref oracle. Pass = green, fail = red.
#
# Usage:
#   bash run_all.sh [--sno2c path/to/sno2c] [--filter pattern]
#
# Dependencies:
#   sno2c     — snobol4x compiler (default: ../snobol4x/src/sno2c/sno2c)
#   gcc       — C compiler with -lgc available
#   libgc-dev — Boehm GC

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Defaults
SNO2C="${SNO2C:-$REPO_ROOT/../snobol4x/src/sno2c/sno2c}"
RUNTIME="$REPO_ROOT/../snobol4x/src/runtime"
FILTER="${1:-}"
TMPDIR_RUN=$(mktemp -d)
trap "rm -rf $TMPDIR_RUN" EXIT

PASS=0; FAIL=0; SKIP=0; ERROR=0

# Colors
GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[0;33m'; RESET='\033[0m'

if [[ ! -x "$SNO2C" ]]; then
    echo "ERROR: sno2c not found at $SNO2C"
    echo "Build with: make -C ../snobol4x/src/sno2c"
    exit 1
fi

run_test() {
    local sno="$1"
    local ref="${sno%.sno}.ref"
    local name
    name=$(basename "$sno" .sno)

    [[ -n "$FILTER" && "$name" != *"$FILTER"* ]] && { SKIP=$((SKIP+1)); return; }
    [[ ! -f "$ref" ]] && { echo -e "${YELLOW}SKIP${RESET} $name (no .ref)"; SKIP=$((SKIP+1)); return; }

    local c_file="$TMPDIR_RUN/${name}.c"
    local bin="$TMPDIR_RUN/${name}"

    # Compile SNOBOL4 → C
    if ! "$SNO2C" "$sno" > "$c_file" 2>/dev/null; then
        echo -e "${RED}FAIL${RESET} $name  [sno2c error]"
        FAIL=$((FAIL+1)); return
    fi

    # Compile C → binary
    local R="$RUNTIME/snobol4"
    if ! gcc -O0 -g "$c_file" \
        "$R/snobol4.c" "$R/snobol4_inc.c" "$R/snobol4_pattern.c" \
        "$RUNTIME/engine.c" \
        -I"$R" -I"$RUNTIME" -lgc -lm -w \
        -o "$bin" 2>/dev/null; then
        echo -e "${RED}FAIL${RESET} $name  [gcc error]"
        FAIL=$((FAIL+1)); return
    fi

    # Run binary, diff against oracle
    local got
    got=$(timeout 5 "$bin" 2>/dev/null || true)
    local exp
    exp=$(cat "$ref")

    if [[ "$got" == "$exp" ]]; then
        echo -e "${GREEN}PASS${RESET} $name"
        PASS=$((PASS+1))
    else
        echo -e "${RED}FAIL${RESET} $name"
        diff <(echo "$exp") <(echo "$got") | head -6 | sed 's/^/      /'
        FAIL=$((FAIL+1))
    fi
}

echo "=== snobol4x crosscheck ==="
echo "sno2c: $SNO2C"
echo ""

DIRS=(output assign concat arith_new control_new patterns capture strings functions data keywords)

for dir in "${DIRS[@]}"; do
    full="$SCRIPT_DIR/$dir"
    [[ -d "$full" ]] || continue
    group_pass=0; group_fail=0
    echo "── $dir ──"
    for sno in "$full"/*.sno; do
        [[ -f "$sno" ]] || continue
        run_test "$sno"
    done
    echo ""
done

echo "============================================"
echo -e "Results: ${GREEN}$PASS passed${RESET}, ${RED}$FAIL failed${RESET}, ${YELLOW}$SKIP skipped${RESET}"
[[ $FAIL -eq 0 ]] && echo -e "${GREEN}ALL PASS${RESET}" && exit 0
exit 1
