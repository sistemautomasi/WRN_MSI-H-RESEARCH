# Phase 5 — One-page summary

**Question**: Do documented and engineered WRN resistance mutations show quantifiable pocket-level effects on HRO761 and VVD-214 docking?

**Method**: 74 Vina dockings (locked exhaustiveness=16, seed=42, box=24 Å) across 3 template states × 2 ligands × 7 mutations + WT + neg-controls, in both non-covalent and covalent-adduct modes. Benchmark redock validated at 1.30 Å (HRO761/9S18) and 1.21 Å (VVD-214/7GQU). Composite verdict: resistance if any of RMSD > 4 Å, ΔScore > 1.5 kcal/mol, or ≥3 contact residues lost.

**Counts**:
- 74 dockings (all completed)
- 21 resistance (37% of 57 computed mutant rows)
- 6 resistance-covalent-blocked (C727A/S vs VVD-214, auto-tagged by chemistry rule)
- 36 neutral
- 2 top 3/3-criteria hits

**Top hits (3/3 criteria)**:

| Docking | ΔScore | RMSD | Contact loss |
|---------|-------:|-----:|-------------:|
| **C727R_9S18_HRO761** | **+6.21** | **11.12 Å** | **13** |
| C727R_9MJT_VVD-214 | +1.82 | 10.51 Å | 13 |

**Cross-validation** (14 rows, 6 papers):
- 6 concordant strong (2 covalent-ablation + 2 C727R + 2 G729D)
- 3 concordant weak (F730L/HRO761, I852F ×2)
- 5 partially concordant (L528S ×2, C727A/S+HRO761, F730L+VVD-214)

**WT baselines confirm pocket biology**: each ligand scores strongest at its own design pocket (HRO761 at 9S18 = -13.54; VVD-214 non-cov at 7GQU = -9.43; VVD-214 cov at 7GQU = -9.12). Neg-controls at 9S19 dimeric off-target are weaker, as expected.

**Skipped**: Chai-1 spot-check (HPC unavailable). Full details in `phase5_missing_data_report.md`.

**All artifacts**: `/mnt/results/phase5_docking_analysis/` (see `README.md`).
