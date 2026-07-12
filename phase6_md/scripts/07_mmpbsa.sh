#!/usr/bin/env bash
# Phase 6 MD — MM/PBSA binding free energy via gmx_MMPBSA
# gmx_MMPBSA: pip install gmx_MMPBSA (needs ambertools)
# We sample 100 evenly-spaced frames from the last 50 ns (50-100 ns window)

set -euo pipefail

WORKDIR="${1:-.}"
cd "$WORKDIR"

echo "[07_mmpbsa] Working in $(pwd)"

# --- Preflight ---
if ! command -v gmx_MMPBSA &>/dev/null; then
    echo "[07_mmpbsa] WARN: gmx_MMPBSA not found — install via pip in Docker image"
    echo "[07_mmpbsa] Skipping MMPBSA analysis"
    exit 0
fi

# --- Write mmpbsa.in config ---
cat > mmpbsa.in << 'EOF'
&general
  sys_name       = "phase6"
  startframe     = 500
  endframe       = 999
  interval       = 5
  temperature    = 310
  verbose        = 1
/

&gb
  igb            = 5
  saltcon        = 0.150
/

&pb
  istrng         = 0.150
  fillratio      = 4.0
  radiopt        = 0
/

&decomp
  idecomp        = 1
  print_res      = "within 4.5"
  csv_format     = 1
/
EOF

# --- Auto-detect receptor + ligand group numbers from index.ndx ---
# gmx_MMPBSA needs: -cs prod.tpr, -ci index.ndx, -cg <receptor_num> <ligand_num>
# We scan index.ndx headers in order and pick the FIRST occurrence of each.
PROT_N=$(python3 -c "
import re
from pathlib import Path
groups = [re.match(r'\[\s*(.+?)\s*\]', l).group(1)
          for l in Path('index.ndx').read_text().splitlines()
          if l.strip().startswith('[')]
try:
    print(groups.index('Protein'))
except ValueError:
    raise SystemExit('Protein group not found in index.ndx')
")
LIG_N=$(python3 -c "
import re
from pathlib import Path
groups = [re.match(r'\[\s*(.+?)\s*\]', l).group(1)
          for l in Path('index.ndx').read_text().splitlines()
          if l.strip().startswith('[')]
try:
    print(groups.index('LIG'))
except ValueError:
    raise SystemExit('LIG group not found in index.ndx')
")
echo "[07_mmpbsa] Groups auto-detected: Protein=$PROT_N LIG=$LIG_N"

gmx_MMPBSA MPI -O -i mmpbsa.in \
    -cs prod.tpr \
    -ci index.ndx \
    -cg "$PROT_N" "$LIG_N" \
    -ct prod_pbc.xtc \
    -cp topol.top \
    -o mmpbsa_results.dat \
    -eo mmpbsa_energy.csv \
    -deo mmpbsa_decomp.csv \
    -nogui

echo "[07_mmpbsa] SUCCESS — see mmpbsa_results.dat + mmpbsa_energy.csv"
