#!/usr/bin/env bash
# Phase 6 MD — Single-system runner
# Useful for debugging or running one system on a smaller GPU

set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <SYSTEM_NAME>"
    echo "  e.g. $0 C727R_9S18_HRO761"
    exit 1
fi

SYS="$1"
PHASE6_ROOT="${PHASE6_ROOT:-/data}"
cd "$PHASE6_ROOT"

if [[ ! -d "inputs/$SYS" ]]; then
    echo "ERROR: inputs/$SYS not found"
    exit 1
fi

echo "==========================================="
echo "Phase 6 MD single-system runner: $SYS"
echo "Start: $(date -Iseconds)"
echo "==========================================="

make prep-$SYS
make prod-$SYS
make check-$SYS
make analyze-$SYS

echo "==========================================="
echo "Phase 6 MD [$SYS] complete"
echo "End: $(date -Iseconds)"
echo "==========================================="
