#!/usr/bin/env bash
# Phase 6 MD — 100 ns production run
# GPU-accelerated (-nb gpu -pme gpu -update gpu) for Vast.ai deployment
# Checkpoint every 10 min (default) — resumable via -cpi if instance dies

set -euo pipefail

WORKDIR="${1:-.}"
cd "$WORKDIR"

echo "[05_production] Working in $(pwd)"
echo "[05_production] Start time: $(date -Iseconds)"

# --- Preflight: verify equilibration outputs ---
for f in npt.gro npt.cpt topol.top index.ndx; do
    if [[ ! -f "$f" ]]; then
        echo "[05_production] ERROR: missing $f — did equilibration complete?" >&2
        exit 1
    fi
done

# --- grompp production ---
gmx grompp -f ../../mdp/prod.mdp \
    -c npt.gro \
    -t npt.cpt \
    -p topol.top \
    -n index.ndx \
    -o prod.tpr -maxwarn 2

# --- mdrun production ---
# -cpi prod.cpt: resume from checkpoint if it exists (instance restart safe)
# -maxh 47:     max wall-clock 47 h/run — set below Vast.ai spot timeout margin
# -deffnm prod: all outputs share basename "prod"
CHECKPOINT_ARG=""
if [[ -f "prod.cpt" ]]; then
    echo "[05_production] RESUMING from prod.cpt"
    CHECKPOINT_ARG="-cpi prod.cpt -append"
fi

gmx mdrun -deffnm prod \
    -nb gpu -pme gpu \
    -update gpu \
    -bonded gpu \
    -pin on -pinstride 1 \
    -maxh 47 \
    -notunepme \
    $CHECKPOINT_ARG \
    -v

echo "[05_production] End time: $(date -Iseconds)"

# --- Verify completion ---
# prod.gro is only written on successful completion of nsteps
if [[ -f prod.gro ]]; then
    echo "[05_production] SUCCESS — 100 ns trajectory complete"
    echo "[05_production] Outputs:"
    ls -lh prod.{gro,xtc,edr,log,cpt}
else
    echo "[05_production] Partial run — restart with same command to continue from checkpoint"
    exit 2
fi
