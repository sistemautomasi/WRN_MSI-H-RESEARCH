#!/usr/bin/env bash
# Phase 6 MD — Standard trajectory analyses
# Assumes prod.xtc + prod.tpr exist after production

set -euo pipefail

WORKDIR="${1:-.}"
cd "$WORKDIR"

echo "[06_analyze] Working in $(pwd)"

# --- 0. PBC-corrected trajectory (nojump, center protein, whole molecules) ---
echo -e "Protein\nSystem" | gmx trjconv \
    -f prod.xtc -s prod.tpr \
    -o prod_pbc.xtc \
    -pbc mol -center -ur compact

# --- 1. Backbone RMSD vs reference (starting structure) ---
echo -e "Backbone\nBackbone" | gmx rms \
    -f prod_pbc.xtc -s prod.tpr \
    -o rmsd_backbone.xvg \
    -tu ns

# --- 2. Ligand RMSD (after fitting on protein backbone) ---
echo -e "Backbone\nLIG" | gmx rms \
    -f prod_pbc.xtc -s prod.tpr \
    -o rmsd_ligand.xvg \
    -tu ns

# --- 3. Per-residue RMSF (last 50 ns for equilibrium sampling) ---
# 50000 ps = 50 ns (nsteps=25M dari 50M)
echo "Backbone" | gmx rmsf \
    -f prod_pbc.xtc -s prod.tpr \
    -o rmsf_backbone.xvg \
    -res \
    -b 50000

# --- 4. Radius of gyration ---
echo "Protein" | gmx gyrate \
    -f prod_pbc.xtc -s prod.tpr \
    -o gyrate.xvg

# --- 5. Ligand-protein H-bonds timecourse ---
echo -e "LIG\nProtein" | gmx hbond \
    -f prod_pbc.xtc -s prod.tpr \
    -num hbond_lig_prot.xvg \
    -dist hbond_dist.xvg \
    -ang hbond_ang.xvg

# --- 6. Distance: residue 727 CA -> ligand COM (min-atom distance) ---
# `gmx pairdist` accepts selection expressions directly; use COM of ligand
# as reference to residue 727 CA. This is portable across GROMACS 5+.
gmx pairdist \
    -f prod_pbc.xtc -s prod.tpr \
    -ref 'resid 727 and name CA' \
    -sel 'com of resname LIG' \
    -type min \
    -o dist_mut727_lig.xvg

# --- 7. Contact map — residues within 4.5 Å of ligand across trajectory ---
echo -e "Protein\nLIG" | gmx mindist \
    -f prod_pbc.xtc -s prod.tpr \
    -on contact_residues.ndx \
    -d 0.45

echo "[06_analyze] SUCCESS — all standard analyses done"
echo "[06_analyze] Outputs: rmsd_backbone.xvg, rmsd_ligand.xvg, rmsf_backbone.xvg,"
echo "                     gyrate.xvg, hbond_lig_prot.xvg, dist_mut727_lig.xvg,"
echo "                     contact_residues.ndx"
