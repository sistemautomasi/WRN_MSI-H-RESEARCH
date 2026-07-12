#!/usr/bin/env bash
# Phase 6 MD — End-to-end runner (all 3 systems sequential)
# Designed to run inside the Docker container on Vast.ai

set -euo pipefail

PHASE6_ROOT="${PHASE6_ROOT:-/data}"
cd "$PHASE6_ROOT"

echo "==========================================="
echo "Phase 6 MD end-to-end runner"
echo "Root: $PHASE6_ROOT"
echo "Start: $(date -Iseconds)"
echo "==========================================="

SYSTEMS=(C727R_9S18_HRO761 WT_9S18_HRO761 C727A_9S18_HRO761)

for sys in "${SYSTEMS[@]}"; do
    echo ""
    echo ">>> [$sys] STARTING <<<"
    T0=$(date +%s)
    
    # Prep (ligand + protein + system + EM + equilibration)
    make prep-$sys 2>&1 | tee inputs/$sys/prep.log
    
    # Production 100 ns
    make prod-$sys 2>&1 | tee inputs/$sys/prod_wall.log
    
    # Sanity check
    make check-$sys 2>&1 | tee inputs/$sys/check.log
    
    # Analyses
    make analyze-$sys 2>&1 | tee inputs/$sys/analyze.log
    
    T1=$(date +%s)
    echo ">>> [$sys] DONE in $(( (T1 - T0) / 3600 )) hours"
done

# Aggregate figures + report
make figures
make report

echo ""
echo "==========================================="
echo "Phase 6 MD complete"
echo "End: $(date -Iseconds)"
echo "==========================================="
echo "Deliverables:"
echo "  - inputs/<system>/prod.xtc + prod.gro (100 ns trajectory)"
echo "  - inputs/<system>/rmsd_*.xvg, rmsf_*.xvg, etc."
echo "  - figures/figA...figG.png/svg/pdf"
echo "  - phase6_report.md"
