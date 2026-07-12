#!/usr/bin/env bash
# Phase 6 MD — Prep protein topology via pdb2gmx
# AMBER99SB-ILDN + TIP3P

set -euo pipefail

WORKDIR="${1:-.}"
cd "$WORKDIR"

echo "[01_prep_protein] Working in $(pwd)"

# 1) Clean crystallographic waters/ions, keep protein atoms only
#    (already done in extract; but strip alt-loc B just in case)
grep -v "^HETATM" protein.pdb | grep -v " B [A-Z][A-Z][A-Z] " > protein_clean.pdb || true
if [[ ! -s protein_clean.pdb ]]; then
    cp protein.pdb protein_clean.pdb
fi

# 2) Run pdb2gmx with AMBER99SB-ILDN + TIP3P
#    -ignh:    strip input H atoms (rebuild from FF)
#    -renum:   renumber residues sequentially
#    -ter:     prompt for terminus type — piped: 0 (NH3+) / 0 (COO-)
#              Change to 1/1 for neutral termini if needed for truncated construct.
#    -missing: don't stop on missing atoms in terminals (kept as we're
#              working with a docking-extracted domain, not full construct)
# For histidines: AMBER99SB-ILDN default is HIE (ε-protonated) — set explicitly
# via -his flag would prompt interactively; we skip it and accept defaults.
gmx pdb2gmx \
    -f protein_clean.pdb \
    -o protein.gro \
    -p protein.top \
    -i posre.itp \
    -ff amber99sb-ildn \
    -water tip3p \
    -ignh \
    -missing \
    -renum \
    -ter << 'EOF'
0
0
EOF

echo "[01_prep_protein] SUCCESS — protein.gro + protein.top ready"
