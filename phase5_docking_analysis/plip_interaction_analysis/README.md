# Phase 5 PLIP Interaction Analysis

Non-covalent interaction fingerprint analysis for all 68 successfully docked WRN complexes
from Phase 5, computed with PLIP v3.0.0 (Schake et al., NAR 2025 gkaf361).

## Contents (git-tracked)

- **`plip_interaction_summary.csv`** — 68 rows × interaction counts per complex (H-bond, hydrophobic, π-stack, π-cation, salt-bridge, halogen, water-bridge) + interacting residue list per complex.
- **`plip_wt_vs_mutant_comparison.csv`** — 57 rows × WT-vs-mutant fingerprint diff (n_lost_plip, n_retained_plip, n_gained_plip, lost_residues, gained_residues).
- **`canonical_mapping_report.csv`** — canonical WRN Q14191 residue mapping for each of the 68 complexes (verifies C727 mapping and total mapped residue count).
- **`2d_ligplot/`** — 68 × 2D LigPlot-style radial diagrams (matplotlib, PNG + SVG). Central ligand box + interacting residues colored by chemistry, interaction lines colored by type.
- **`wt_vs_mutant_comparisons/`** — 4 × side-by-side WT vs mutant composites for the top-tier resistance hits.

## Not tracked (regenerable from full pipeline)

- `3d_pymol/` — 68 × custom PyMOL 3D annotated screenshots (1200×900, ~32 MB)
- `canonical_complexes/` — 68 × renumbered PDBs (~23 MB)
- `plip_reports_bundle/` — PLIP XML+text reports per complex (~9 MB)

All available in the atlas PDF: `../phase5_interaction_atlas.pdf` (85 pages, ~53 MB).

## Methods summary

1. **Canonical numbering**: 68 complex PDBs realigned to WRN Q14191 (1432 aa) via Biopython PairwiseAligner (global, match=2, mismatch=−3, gap_open=−10, extend=−0.5). Mismatch at mutation position accepted. Verified C727 mapping on all 68 complexes; mean 424.1/425 residues mapped (99.8%).
2. **PLIP detection**: PLIP v3.0.0 CLI with `-t --xml -p` on protonated complexes. Detects 7 non-covalent interaction classes using published geometric criteria (H-bond ≤3.5 Å + ≤120°, hydrophobic ≤4 Å, π-stack ≤5.5 Å, halogen ≤4 Å + ≤140°).
3. **Fingerprint diff**: For each of the 57 mutant complexes, matched to its corresponding WT complex on (template, ligand, cov_status) and compared PLIP-detected residue sets.

## Key findings

- **CYS727 lost in 4/4 top hits** (mutation site itself, expected)
- **9 residues lost 3/4**: VAL552, ARG711, ILE725, THR726, PHE730, GLY825, GLU846, TYR849, GLN850
- **Per-mutation mean lost residues**: C727R 3.56, C727S 2.67, C727A 2.67, G729D 0.89, L528S 0.33, I852F 0.22, F730L 0.11

C727R disrupts the most fingerprint contacts across templates, consistent with the Phase 5 verdict tiering.
