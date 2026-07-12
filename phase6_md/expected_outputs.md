# Phase 6 MD — Expected outputs at each stage

Reference document showing what files should appear after each script.
Use this to verify pipeline progress or debug missing outputs.

---

## After `00_prep_ligand.py` (per system)

```
inputs/<SYSTEM>/
├── ligand.pdb                    (input, exists already)
├── ligand.smi                    (input, exists already)
├── ligand_H.pdb                  ← OpenBabel output (H-added)
├── ligand_H.mol2                 ← OpenBabel output (mol2 format)
├── LIG.acpype/
│   ├── LIG_GMX.gro               ← GROMACS coords for LIG
│   ├── LIG_GMX.itp               ← force field include (atomtypes + moleculetype)
│   ├── LIG_GMX.top               ← standalone topology
│   └── posre_LIG.itp             ← position restraints on heavy atoms
├── LIG.gro → LIG.acpype/LIG_GMX.gro     (symlink)
├── LIG.itp → LIG.acpype/LIG_GMX.itp     (symlink)
└── posre_LIG.itp → LIG.acpype/posre_LIG.itp   (symlink)
```

Sanity check:
- `LIG.itp` should contain `[ atomtypes ]` block (needed for `topol.top`)
- `LIG.gro` should have 51+ atoms (HRO761 heavy + all hydrogens)

---

## After `01_prep_protein.sh`

```
inputs/<SYSTEM>/
├── protein.pdb                   (input)
├── protein_clean.pdb             ← altloc B stripped
├── protein.gro                   ← pdb2gmx output
├── protein.top                   ← force field-referenced topology
└── posre.itp                     ← position restraints on protein heavy atoms
```

Sanity check:
- `protein.gro` first line is title, second is atom count
- Should include all AMBER-standard residues (no `Residue X not found` errors)

---

## After `02_build_system.sh`

```
inputs/<SYSTEM>/
├── complex.gro                   ← merged protein + LIG (before solvation)
├── topol.top                     ← merged topology with #include "LIG.itp"
├── box.gro                       ← after editconf (box added)
├── solvated.gro                  ← after solvate (TIP3P added)
├── ions.tpr                      ← genion input .tpr
└── ionised.gro                   ← after genion (Na+/Cl- added, ~50k atoms total)
```

Sanity check:
- `ionised.gro` should have ~50,000 atoms
- `topol.top` `[ molecules ]` should include:
  ```
  Protein_chain_A     1
  LIG                 1
  SOL                 ~15000
  NA                  ~35
  CL                  ~35
  ```

---

## After `03_minimize.sh`

```
inputs/<SYSTEM>/
├── index.ndx                     ← custom groups (Protein_LIG, Water_and_ions)
├── em.tpr
├── em.gro                        ← energy-minimised structure
├── em.edr                        ← energies
├── em.log
├── em.trr                        ← minimisation trajectory (small)
└── em_potential.xvg              ← reported by gmx energy
```

Sanity check:
- Final potential energy should be negative (typically −5×10⁵ to −1×10⁶ kJ/mol)
- `em.log` should show "Steepest Descents converged to Fmax < 500"

---

## After `04_equilibrate.sh`

```
inputs/<SYSTEM>/
├── nvt.tpr
├── nvt.gro                       ← after 200 ps NVT
├── nvt.cpt                       ← checkpoint
├── nvt.edr
├── nvt.log
├── nvt.xtc                       ← trajectory (compressed)
├── nvt_temp.xvg                  ← temperature vs time
├── npt.tpr
├── npt.gro                       ← after 500 ps NPT
├── npt.cpt
├── npt.edr
├── npt.log
├── npt.xtc
└── npt_density_pressure.xvg
```

Sanity check:
- `nvt_temp.xvg` mean ≈ 310 ± 2 K
- `npt_density_pressure.xvg` density ≈ 1000 kg/m³ (TIP3P bulk)

---

## After `05_production.sh` (ALL SYSTEMS COMPLETE)

```
inputs/<SYSTEM>/
├── prod.tpr
├── prod.gro                      ← final structure (only after full 100 ns)
├── prod.cpt                      ← last checkpoint
├── prod.edr                      ← energies (~500 MB)
├── prod.log                      ← run log (~10 MB)
└── prod.xtc                      ← trajectory, 1000 frames (~5 GB)
```

Sanity check:
- File sizes: prod.xtc ~ 5 GB (100 ns × 1000 frames × ~50k atoms × 4 bytes ≈ 5 GB)
- `prod.log` last line should say "Finished mdrun"
- Wall time: ~48 h on RTX 4090

---

## After `06_analyze.sh`

```
inputs/<SYSTEM>/
├── prod_pbc.xtc                  ← PBC-corrected trajectory
├── rmsd_backbone.xvg             ← protein backbone RMSD vs starting
├── rmsd_ligand.xvg               ← ligand heavy-atom RMSD (fit on backbone)
├── rmsf_backbone.xvg             ← per-residue RMSF (last 50 ns)
├── gyrate.xvg                    ← protein Rg
├── hbond_lig_prot.xvg            ← H-bond count timecourse
├── hbond_dist.xvg
├── hbond_ang.xvg
├── dist_mut727_lig.xvg           ← Cys/Arg/Ala 727 CA to LIG COM
├── contact_residues.ndx          ← residues within 4.5 Å of LIG
└── mut727_lig.ndx
```

---

## After `07_mmpbsa.sh`

```
inputs/<SYSTEM>/
├── mmpbsa.in                     ← config
├── mmpbsa_results.dat            ← human-readable summary
├── mmpbsa_energy.csv             ← per-frame ΔG (100 frames)
└── mmpbsa_decomp.csv             ← per-residue decomposition
```

Sanity check:
- `mmpbsa_results.dat` should have a "DELTA TOTAL" line
- Typical ΔG for HRO761-WRN is −25 to −40 kcal/mol (approximate; MM-PBSA is
  known to overestimate binding vs. experimental Kd)

---

## After `08_make_figures.py` (in phase6_md/ root)

```
figures/
├── figA_rmsd_backbone.png/.svg/.pdf
├── figB_rmsd_ligand.png/.svg/.pdf
├── figC_rmsf.png/.svg/.pdf
├── figD_hbonds.png/.svg/.pdf
├── figE_dist_mut727.png/.svg/.pdf
├── figF_gyrate.png/.svg/.pdf
└── figG_mmpbsa.png/.svg/.pdf
```

Each figure: 300 dpi, editable SVG text (svg.fonttype=none), Phylo palette.

---

## After `make report`

```
phase6_report.md                  ← aggregated pass/fail from all systems
```
