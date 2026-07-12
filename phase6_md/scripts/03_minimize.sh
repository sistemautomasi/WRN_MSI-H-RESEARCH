#!/usr/bin/env bash
# Phase 6 MD — Energy minimisation (steepest descent) + index groups
# Robust: auto-detects group numbers by parsing `gmx make_ndx` list.

set -euo pipefail

WORKDIR="${1:-.}"
cd "$WORKDIR"

echo "[03_minimize] Working in $(pwd)"

# ---------------------------------------------------------------------------
# 1) Build custom index groups for temperature coupling.
#    tc-grps in nvt/npt/prod.mdp = "Protein_LIG Water_and_ions"
#
#    Strategy: interrogate make_ndx to enumerate existing groups, then feed
#    it a script that combines the correct ones by NAME (not by hardcoded
#    numbers), because group numbering depends on the FF + solvation history.
# ---------------------------------------------------------------------------

# Dump group list (make_ndx prints groups then exits on 'q')
GROUPS=$(printf "q\n" | gmx make_ndx -f ionised.gro -o /tmp/index_probe.ndx 2>&1 | \
         grep -E "^\s*[0-9]+\s+[A-Za-z]" || true)

# Extract number for a named group; returns "" if absent
grp_num() {
    echo "$GROUPS" | awk -v name="$1" '$2 == name { print $1; exit }'
}

PROT_N=$(grp_num "Protein")
LIG_N=$(grp_num "LIG")
WAT_N=$(grp_num "Water")
ION_N=$(grp_num "Ion")

# Sanity
if [[ -z "$PROT_N" ]]; then
    echo "[03_minimize] FATAL: no 'Protein' group found. Check ionised.gro is correct."
    echo "Groups seen:"; echo "$GROUPS"; exit 1
fi
if [[ -z "$LIG_N" ]]; then
    echo "[03_minimize] FATAL: no 'LIG' group found. Check ligand was included in topol.top."
    echo "Groups seen:"; echo "$GROUPS"; exit 1
fi
if [[ -z "$WAT_N" ]]; then
    echo "[03_minimize] FATAL: no 'Water' group found."
    echo "Groups seen:"; echo "$GROUPS"; exit 1
fi

echo "[03_minimize] Detected groups: Protein=$PROT_N LIG=$LIG_N Water=$WAT_N Ion=${ION_N:-<none>}"

# Build make_ndx script: combine Protein + LIG, combine Water + Ion (if present)
if [[ -n "$ION_N" ]]; then
    WATER_ION_CMD="$WAT_N | $ION_N"
else
    # No ions (unlikely at 0.15 M NaCl on charged protein); use Water alone
    WATER_ION_CMD="$WAT_N"
fi

# Feed script - use here-doc; last "q" saves & exits.
# After combining, we RENAME the combined groups so mdp tc-grps = "Protein_LIG Water_and_ions"
# works. make_ndx numbers newly created groups sequentially at the end.
# We probe the resulting file after to confirm the names.
gmx make_ndx -f ionised.gro -o index.ndx << EOF
$PROT_N | $LIG_N
$WATER_ION_CMD
q
EOF

# Confirm and rename by scanning index.ndx headers
python3 << 'PYEOF'
from pathlib import Path
import re, sys

lines = Path("index.ndx").read_text().splitlines()
groups = [re.match(r'\[\s*(.+?)\s*\]', l).group(1) for l in lines if l.strip().startswith('[')]
print(f"[03_minimize] Groups in index.ndx: {groups}")

# The last two groups (created above) are the combined ones. Rename them.
# GROMACS default naming after `A | B` is "A_B" so we should have e.g. "Protein_LIG" and "Water_Ion"
def rename(old, new):
    txt = Path("index.ndx").read_text()
    if f"[ {old} ]" in txt:
        txt = txt.replace(f"[ {old} ]", f"[ {new} ]", 1)
        Path("index.ndx").write_text(txt)
        print(f"[03_minimize] Renamed [{old}] -> [{new}]")
    else:
        print(f"[03_minimize] Group [{old}] not found (may already be renamed).")

# LIG group in acpype is 'LIG'; combined is 'Protein_LIG' (correct already)
# Water+Ion combined name from make_ndx is 'Water_Ion' → rename to 'Water_and_ions'
rename("Water_Ion", "Water_and_ions")
# If there were no ions, the combined name won't exist; use Water directly
if "Water_and_ions" not in Path("index.ndx").read_text():
    rename("Water", "Water_and_ions_fallback")  # will not match tc-grps; user will get grompp error → intentional
PYEOF

# ---------------------------------------------------------------------------
# 2) grompp EM (uses only System group, index optional but safer to pass)
# ---------------------------------------------------------------------------
gmx grompp -f ../../mdp/em.mdp -c ionised.gro -p topol.top -o em.tpr -n index.ndx -maxwarn 2

# ---------------------------------------------------------------------------
# 3) mdrun EM
# ---------------------------------------------------------------------------
gmx mdrun -deffnm em -v

echo "[03_minimize] SUCCESS — em.gro (minimised) ready"

# Report final potential energy
echo "Potential" | gmx energy -f em.edr -o em_potential.xvg
tail -30 em_potential.xvg | grep -v "^[@#]" | tail -5
