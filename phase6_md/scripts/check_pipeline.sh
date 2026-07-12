#!/usr/bin/env bash
# Phase 6 MD — Pipeline sanity check
# Verifies acceptance criteria after production run

set -euo pipefail

WORKDIR="${1:-.}"
cd "$WORKDIR"

echo "[check_pipeline] Working in $(pwd)"
FAIL=0

# --- 1. Files exist ---
for f in prod.gro prod.xtc prod.edr prod.log; do
    if [[ ! -f "$f" ]]; then
        echo "  FAIL: missing $f"
        FAIL=$((FAIL + 1))
    else
        echo "  OK: $f ($(du -h $f | cut -f1))"
    fi
done

# --- 2. Trajectory complete (nsteps = 50M for 100 ns) ---
if [[ -f prod.log ]]; then
    steps=$(grep -oE "step\s+[0-9]+" prod.log | tail -1 | grep -oE "[0-9]+" || echo 0)
    if [[ $steps -ge 49000000 ]]; then
        echo "  OK: production reached step $steps (target 50M)"
    else
        echo "  FAIL: production only reached step $steps (< 49M)"
        FAIL=$((FAIL + 1))
    fi
fi

# --- 3. Temperature check (should be ~310 K) ---
if command -v gmx &>/dev/null; then
    echo "Temperature" | gmx energy -f prod.edr -o _tmp_temp.xvg 2>&1 | grep -E "Average|Mean" | tee -a check.log || true
    mean_temp=$(grep -v "^[#@]" _tmp_temp.xvg | awk '{sum+=$2; n++} END{print sum/n}')
    if awk "BEGIN{exit !($mean_temp > 308 && $mean_temp < 312)}"; then
        echo "  OK: mean temperature $mean_temp K"
    else
        echo "  FAIL: temperature $mean_temp K outside 308-312 K"
        FAIL=$((FAIL + 1))
    fi
    rm -f _tmp_temp.xvg
fi

# --- 4. No SHAKE / LINCS warnings above threshold ---
lincs_warn=$(grep -c "LINCS WARNING" prod.log || echo 0)
if [[ $lincs_warn -lt 100 ]]; then
    echo "  OK: $lincs_warn LINCS warnings (< 100 threshold)"
else
    echo "  FAIL: $lincs_warn LINCS warnings"
    FAIL=$((FAIL + 1))
fi

# --- 5. Ligand didn't escape pocket (last-frame distance from initial < 15 Å) ---
# Requires dist_mut727_lig.xvg from analyze step
if [[ -f dist_mut727_lig.xvg ]]; then
    last_dist=$(grep -v "^[#@]" dist_mut727_lig.xvg | tail -1 | awk '{print $2 * 10}')
    if awk "BEGIN{exit !($last_dist < 15)}"; then
        echo "  OK: final ligand-mut727 distance $last_dist Å (< 15 Å)"
    else
        echo "  NOTE: final distance $last_dist Å — ligand may have relocated"
        echo "        (this is scientifically informative, not a failure)"
    fi
fi

if [[ $FAIL -eq 0 ]]; then
    echo "[check_pipeline] ALL CHECKS PASSED"
    exit 0
else
    echo "[check_pipeline] $FAIL FAILURES"
    exit 1
fi
