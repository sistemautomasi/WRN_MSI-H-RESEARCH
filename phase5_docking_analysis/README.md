# Phase 5 — Docking analysis

Extension of the Phase 4 WRN druggable-pocket atlas with quantitative docking evidence for HRO761 and VVD-214 against 7 resistance mutations across 3 template states.

## Quick start

- Start with **`phase5_summary.md`** (one page).
- Full write-up: **`phase5_docking_report.md`**.
- Skipped items and workarounds: **`phase5_missing_data_report.md`**.
- Orthogonal Chai-1 attempt (inconclusive): **`chai1_orthogonal/README.md`**.
- Reproducibility: **`phase5_verification_checklist.md`**.

## Directory contents

```
phase5_docking_analysis/
├── README.md                              ← this file
├── phase5_docking_report.md               ← full report (10 sections)
├── phase5_summary.md                      ← one-page executive summary
├── phase5_missing_data_report.md          ← skipped items + workarounds
├── phase5_verification_checklist.md       ← 30-point audit
│
├── ligand_pdbqt/                          ← 3 ligand PDBQTs (HRO761, VVD-214, VVD-214_cov)
├── receptor_pdbqt/                        ← 32 receptor PDBQTs (4 templates × 8 states)
├── reference_poses/                       ← co-crystal reference PDBs for benchmark redock
├── poses/                                 ← Vina pose PDBQT outputs (ligand-only)
├── complexes/                             ← 68 receptor+ligand merged PDBs (visualisation-ready) + 6 blocked notes
├── chai1_orthogonal/                      ← Chai-1 orthogonal co-fold attempt (10 systems, INCONCLUSIVE — see subfolder README)
├── logs/                                  ← batch runtime logs
│
├── dock_scores_raw.csv                    ← 50 non-cov rows (Vina primary output)
├── dock_scores_cov.csv                    ← 24 cov rows (alias of _covalent_raw)
├── dock_scores_covalent_raw.csv           ← 24 cov rows (18 ok + 6 auto-blocked)
│
├── vina_poses.csv                         ← 74 rows w/ contact residues (canonical WRN)
├── vina_poses_with_rmsd.csv               ← 57 mutant computed rows w/ pose RMSD vs WT
│
├── phase5_master.csv                      ← 74 rows × 28 cols (grand join)
├── phase5_verdicts.csv                    ← 63 mutant-only rows w/ verdicts
├── phase5_cross_validation.csv            ← 14 rows (7 mutations × 2 ligands)
├── phase5_summary.csv                     ← 74 rows × 14 simplified cols
├── preview_signals.csv                    ← superseded by verdicts (retained for provenance)
│
└── figures/                               ← 7 figures, PNG + SVG (200 DPI)
    ├── fig1_benchmark_redock              ← HRO761 1.30 Å, VVD-214 1.21 Å
    ├── fig2_score_heatmap                 ← mut × state score matrix per ligand
    ├── fig3_delta_score_heatmap           ← ΔScore diverging heatmap
    ├── fig4_pose_rmsd_heatmap             ← pose RMSD vs WT
    ├── fig5_verdict_summary               ← stacked bars per mutation
    ├── fig6_cross_validation              ← literature concordance table
    └── fig7_contact_loss_top_hits         ← lost contact residues for top-4 signals
```

## Headline numbers

| Metric | Value |
|--------|-------|
| Total dockings | **74** |
| Benchmark RMSD (HRO761 → 9S18) | **1.30 Å** ✓ |
| Benchmark RMSD (VVD-214 → 7GQU) | **1.21 Å** ✓ |
| Top signal: **C727R_9S18_HRO761** | **ΔScore = +6.21 kcal/mol**, RMSD **11.12 Å**, **13** contacts lost |
| Resistance verdicts | 21 computed + 6 covalent-blocked |
| Concordant strong with literature | 6 of 14 rows |

## Key methods (see report §2 for full detail)

- Vina 1.2.5, exhaustiveness=16, seed=42, box=24 Å per template
- Ligands: HRO761 (non-covalent) and VVD-214 (non-covalent + covalent-adduct)
- Templates: 9MJT (ATP pocket), 9S18 (HRO761 design), 7GQU (VVD-214 design), 9S19 (off-target neg-control)
- Mutations: L528S, C727A, C727S, C727R, G729D, F730L, I852F
- Composite verdict (any-of-3): pose RMSD > 4 Å, ΔScore > 1.5 kcal/mol, ≥ 3 contact residues lost
- C727A/S vs VVD-214 covalent runs auto-tagged `covalent_blocked` (no thiol nucleophile)
- Canonical WRN numbering restored via per-template offset map (I852F sequence probe)

## References

Six papers cited, DOIs verified from Phase 4 reference set. Full list in `phase5_docking_report.md` §10.
