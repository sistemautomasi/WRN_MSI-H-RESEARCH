#!/usr/bin/env bash
# Phase 6 MD — Merge protein + ligand topology, solvate, ionise
# AMBER99SB-ILDN protein + GAFF2 ligand + TIP3P water + 0.15 M NaCl

set -euo pipefail

WORKDIR="${1:-.}"
cd "$WORKDIR"

echo "[02_build_system] Working in $(pwd)"

# --- Step 1: merge protein.gro + LIG.gro into complex.gro ---
# Read protein.gro atoms and append LIG atoms before box vector line.
python3 << 'PYEOF'
from pathlib import Path

def read_gro(path):
    lines = path.read_text().splitlines()
    title = lines[0]
    natoms = int(lines[1])
    atoms = lines[2:2+natoms]
    box = lines[2+natoms]
    return title, natoms, atoms, box

pt, pn, pa, pbox = read_gro(Path("protein.gro"))
lt, ln, la, lbox = read_gro(Path("LIG.gro"))

# Renumber LIG atom serials to continue after protein
new_la = []
for i, line in enumerate(la, start=1):
    # gro format: %5d%-5s%5s%5d ... but LIG serials come from acpype starting at 1
    # We only need to keep the columns consistent; GROMACS doesn't require unique serials in .gro
    new_la.append(line)

merged = [
    "Phase 6 complex (protein + LIG)",
    f"{pn + ln:5d}",
    *pa,
    *new_la,
    pbox,
]
Path("complex.gro").write_text("\n".join(merged) + "\n")
print(f"Merged: {pn} protein + {ln} ligand = {pn+ln} atoms")
PYEOF

# --- Step 2: build merged topol.top ---
# Copy protein.top -> topol.top, insert LIG include and [molecules]
python3 << 'PYEOF'
from pathlib import Path
import re

top = Path("protein.top").read_text()

# Insert #include of LIG atomtypes+params BEFORE the first #include of forcefield.itp
# and #include of ligand's molecule .itp after.
# acpype writes atomtypes in the same LIG_GMX.itp; we need it after ff include
# Simplest safe pattern: insert LIG.itp include right after '#include "amber99sb-ildn.ff/forcefield.itp"'

ff_incl = re.search(r'^\s*#include\s+"amber99sb-ildn\.ff/forcefield\.itp"\s*$', top, re.M)
if not ff_incl:
    raise SystemExit("Could not find AMBER FF include in protein.top")

# The LIG_GMX.itp from acpype contains BOTH atomtypes and the LIG moleculetype.
# For GROMACS, atomtypes MUST appear before any moleculetype uses them.
# acpype's LIG_GMX.itp is structured as: [ atomtypes ] block first, then [ moleculetype ] LIG.
# So a single #include of LIG.itp AFTER the forcefield include is correct.

insert_point = ff_incl.end()
lig_include = '\n#include "LIG.itp"\n'
top_new = top[:insert_point] + lig_include + top[insert_point:]

# Inject posre_LIG include INSIDE the LIG moleculetype block so -DPOSRES
# activates heavy-atom restraints on the ligand during NVT/NPT.
# acpype's LIG.itp already contains a `#ifdef POSRES ... #include "posre_LIG.itp" ... #endif`
# block by default; we only need to make sure it's present. Check and inject if missing.
lig_itp_path = Path("LIG.itp").resolve()
lig_itp_text = lig_itp_path.read_text()
if 'posre_LIG.itp' not in lig_itp_text:
    lig_itp_text = lig_itp_text.rstrip() + (
        "\n\n; Position restraints on ligand heavy atoms (active with -DPOSRES)\n"
        "#ifdef POSRES\n"
        "#include \"posre_LIG.itp\"\n"
        "#endif\n"
    )
    lig_itp_path.write_text(lig_itp_text)
    print("[02_build_system] Injected posre_LIG.itp include into LIG.itp")
else:
    print("[02_build_system] LIG.itp already includes posre_LIG.itp")

# Append LIG to [ molecules ] section
mol_block = re.search(r'(\[\s*molecules\s*\][^\[]*)$', top_new, re.M | re.S)
if not mol_block:
    raise SystemExit("Could not find [molecules] block")

top_new = top_new + ("\n" if not top_new.endswith("\n") else "") + "LIG                 1\n"

Path("topol.top").write_text(top_new)
print("topol.top written with LIG include + LIG in molecules")
PYEOF

# --- Step 3: define simulation box (cubic, 1.0 nm buffer from protein) ---
gmx editconf -f complex.gro -o box.gro -c -d 1.0 -bt cubic

# --- Step 4: solvate with TIP3P water ---
gmx solvate -cp box.gro -cs spc216.gro -p topol.top -o solvated.gro

# --- Step 5: add ions to 0.15 M NaCl + neutralize ---
# grompp needs any .mdp; use ions.mdp
gmx grompp -f ../../mdp/ions.mdp -c solvated.gro -p topol.top -o ions.tpr -maxwarn 2

# genion: replace SOL with Na+/Cl-, neutralise + 0.15 M
# Select "SOL" group (usually index 15 or similar) - use echo pipe robustly via -pname/-nname
echo "SOL" | gmx genion \
    -s ions.tpr \
    -o ionised.gro \
    -p topol.top \
    -pname NA -nname CL \
    -neutral -conc 0.15

echo "[02_build_system] SUCCESS — ionised.gro + topol.top ready for EM"
