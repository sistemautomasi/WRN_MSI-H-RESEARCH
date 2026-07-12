#!/usr/bin/env bash
# Phase 6 MD — 2-stage equilibration
#   Stage A: NVT 200 ps at 310 K (restraints on protein + LIG heavy atoms)
#   Stage B: NPT 500 ps at 310 K, 1 atm (restraints still on)

set -euo pipefail

WORKDIR="${1:-.}"
cd "$WORKDIR"

echo "[04_equilibrate] Working in $(pwd)"

# --- Stage A: NVT ---
gmx grompp -f ../../mdp/nvt.mdp \
    -c em.gro \
    -r em.gro \
    -p topol.top \
    -n index.ndx \
    -o nvt.tpr -maxwarn 2

gmx mdrun -deffnm nvt \
    -nb gpu -pme gpu \
    -update gpu \
    -pin on \
    -v

# Report temperature convergence
echo "Temperature" | gmx energy -f nvt.edr -o nvt_temp.xvg
echo "[04_equilibrate] NVT complete — see nvt_temp.xvg"

# --- Stage B: NPT ---
gmx grompp -f ../../mdp/npt.mdp \
    -c nvt.gro \
    -r nvt.gro \
    -t nvt.cpt \
    -p topol.top \
    -n index.ndx \
    -o npt.tpr -maxwarn 2

gmx mdrun -deffnm npt \
    -nb gpu -pme gpu \
    -update gpu \
    -pin on \
    -v

# Report density + pressure convergence
echo -e "Density\nPressure" | gmx energy -f npt.edr -o npt_density_pressure.xvg
echo "[04_equilibrate] NPT complete — see npt_density_pressure.xvg"

echo "[04_equilibrate] SUCCESS — npt.gro (equilibrated) ready for production"
