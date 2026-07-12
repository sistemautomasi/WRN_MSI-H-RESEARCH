#!/usr/bin/env bash
# Phase 6 MD — Analysis-only runner
# Run this after prod.xtc + prod.tpr already exist (e.g. rerunning figures)

set -euo pipefail

PHASE6_ROOT="${PHASE6_ROOT:-/data}"
cd "$PHASE6_ROOT"

SYSTEMS=(C727R_9S18_HRO761 WT_9S18_HRO761 C727A_9S18_HRO761)

for sys in "${SYSTEMS[@]}"; do
    if [[ -f inputs/$sys/prod.xtc ]]; then
        echo ">>> [$sys] analyses"
        make analyze-$sys
    else
        echo ">>> [$sys] SKIP (no prod.xtc)"
    fi
done

make figures
make report

echo ">>> Analysis-only run complete"
