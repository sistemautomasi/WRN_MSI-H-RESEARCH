# Phase 5 — Verification checklist

30-point audit for reproducibility. Every checkbox below is met by the deliverables shipped in `/mnt/results/phase5_docking_analysis/`. To regenerate any single checkpoint, follow the "how to reproduce" line.

## A. Input preparation (checks 1–6)

- [x] **1. Ligand PDBQT prepared for HRO761**. File: `ligand_pdbqt/HRO761.pdbqt`. Reproduce: Meeko `mk_prepare_ligand.py -i HRO761.sdf -o HRO761.pdbqt`.
- [x] **2. Ligand PDBQT prepared for VVD-214 (non-cov)**. File: `ligand_pdbqt/VVD-214.pdbqt`.
- [x] **3. Ligand PDBQT prepared for VVD-214 (cov-adduct)**. File: `ligand_pdbqt/VVD-214_cov.pdbqt`.
- [x] **4. 32 receptor PDBQTs prepared** (4 templates × 8 states = WT + 7 mutations). Folder: `receptor_pdbqt/`. Reproduce: PDBFixer + Meeko `mk_prepare_receptor.py` per template with Phase 3 side-chain replacement.
- [x] **5. Cys727 tag present** in all VVD-214 covalent-adduct receptors (except C727A/S/R). Reproduce: `grep "TAG C727" receptor_pdbqt/*_cov.pdbqt`.
- [x] **6. Benchmark redock PDBs staged** in `reference_poses/` (HRO761 co-crystal, VVD-214 co-crystal).

## B. Benchmark validation (checks 7–8)

- [x] **7. HRO761 redock RMSD ≤ 2 Å**. Result: **1.30 Å** to 9S18 co-crystal, score -13.54 kcal/mol. See `figures/fig1_benchmark_redock.png`.
- [x] **8. VVD-214 redock RMSD ≤ 2 Å**. Result: **1.21 Å** to 7GQU co-crystal (non-cov form), score -9.425 kcal/mol.

## C. Docking execution (checks 9–14)

- [x] **9. Locked Vina parameters** used across all 74 dockings: `exhaustiveness=16, num_modes=10, energy_range=5, seed=42, cpu=1, size=24 Å`.
- [x] **10. Non-covalent batch: 50 dockings completed**. File: `dock_scores_raw.csv` has 50 rows, all `status=ok`. Reproduce: `python run_vina_noncov.py` on `receptor_pdbqt/` + `ligand_pdbqt/HRO761.pdbqt` and `VVD-214.pdbqt`.
- [x] **11. Covalent batch: 18 ok + 6 blocked = 24 rows total**. File: `dock_scores_covalent_raw.csv` has 24 rows. Reproduce: `python run_vina_cov.py`.
- [x] **12. All C727A/S vs VVD-214 covalent rows** tagged `covalent_blocked` (n=6). Confirm: `grep covalent_blocked dock_scores_covalent_raw.csv | wc -l → 6`.
- [x] **13. All WT baselines present** for 3 templates × 2 ligands × 2 modes (9 rows). Confirm in `phase5_master.csv`: `is_wt=True & ~is_neg_control` → 9 rows.
- [x] **14. Two 9S19 neg-controls present**. Confirm: `is_neg_control=True` → 2 rows.

## D. Pose analysis (checks 15–20)

- [x] **15. All 74 dockings have contact residues** (except 6 covalent-blocked). Confirm in `vina_poses.csv`.
- [x] **16. Canonical WRN numbering applied**. Sanity: `CYS727` appears in `WT_9S18_HRO761` contact set.
- [x] **17. Numbering offsets documented** in code and report: `{9MJT: 17, 9S18: 21, 7GQU: 11}` mut→WT; `{9MJT: +499, 9S18: +500, 7GQU: +515}` WT→canonical.
- [x] **18. 9S19 numbering flagged separately** — chain-prefixed 9S19-local (no canonical mapping).
- [x] **19. Pose RMSD vs WT computed for all 57 mutant computed rows**. File: `vina_poses_with_rmsd.csv`.
- [x] **20. F730L smoke test passes**: for identical pose (RMSD 0.05 Å), ≤ 2 unique contacts either side. Post-fix, F730L_9MJT_VVD-214 shows 22/23 shared, 1 unique per side.

## E. Aggregation & verdicts (checks 21–25)

- [x] **21. Master CSV: 74 rows × 28 cols** (`phase5_master.csv`).
- [x] **22. Verdict CSV: 63 rows** (57 computed + 6 covalent-blocked) (`phase5_verdicts.csv`).
- [x] **23. Verdict counts match report**: 21 resistance + 6 cov-blocked + 36 neutral = 63 mutant rows.
- [x] **24. Cross-validation: 14 rows** (7 mutations × 2 ligands) (`phase5_cross_validation.csv`).
- [x] **25. Concordance categories match report**: 6 concordant strong + 3 concordant weak + 5 partially concordant = 14.

## F. Figures (checks 26–30)

- [x] **26. 7 figures generated, PNG + SVG each**. Folder: `figures/` → 14 files.
- [x] **27. Benchmark figure passes** (fig1). Media check status: pass.
- [x] **28. Score/ΔScore/RMSD heatmaps pass** (fig2, fig3, fig4). Media check status: pass.
- [x] **29. Verdict summary + cross-validation figures pass** (fig5, fig6). fig6 required 6 layout iterations before passing the media check.
- [x] **30. Contact-loss figure passes** (fig7). Visually verified: 4 top hits, canonical residue labels, no overlap.

## Reproducibility notes

- **Environment**: Vina 1.2.5, Meeko, PDBFixer, RDKit. Python packages: pandas, numpy, matplotlib, seaborn, MDAnalysis (for RMSD).
- **Random seed**: Vina locked at 42.
- **Order of execution**: benchmark → non-cov batch → cov batch → pose analysis (with numbering fix) → aggregation → figures → reports.
- **Full command log**: available in `/mnt/results/execution_trace/worker-0.ipynb` (Jupyter notebook trace).
