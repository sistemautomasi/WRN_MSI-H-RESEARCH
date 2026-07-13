# Phase 5A: Docking Interaction Atlas (Paper Submission Package)

Publication-quality protein-ligand interaction analysis for all 68 successfully docked WRN complexes
from the Phase 5 resistance-mutation campaign. Non-covalent contacts detected with PLIP v3.0.0
(Schake et al., NAR 2025 gkaf361) using published geometric criteria. All residue numbers realigned
to canonical WRN UniProt Q14191 (1432 aa) via Biopython PairwiseAligner.

## Folder structure

```
phase5A_docking_interactions/
├── 01_2d_ligplot_diagrams/         68 PNG + 68 SVG — custom matplotlib 2D radial diagrams
├── 02_pymol_3d_annotated/          68 PNG — custom PyMOL 3D screenshots with residue labels
├── 03_plip_native_3d/              68 PNG — PLIP-generated PyMOL binding-site renders
├── 04_wt_vs_mutant_comparisons/    4 PNG — side-by-side WT vs mutant composites (top hits)
├── 05_key_figures/                 5 publication-ready figures (Fig 1–5, PNG + SVG)
├── tables/                         3 CSV — interaction summary, WT-vs-mutant diff, canonical mapping
├── supplementary_pdb/              68 PDB — canonically renumbered complexes for reproducibility
└── README.md                       This file
```

## Key figures (`05_key_figures/`)

| File | Description |
|---|---|
| `Fig1_per_mutation_disruption.png/.svg` | Horizontal bars showing mean lost/retained/gained PLIP fingerprint residues per mutation, sorted by disruption magnitude. Validates verdict tiering: C727R > C727S ≈ C727A ≫ G729D > L528S > I852F ≈ F730L. |
| `Fig2_interaction_type_composition.png/.svg` | Stacked bar showing mean interaction-type composition (H-bond, hydrophobic, π-stack, π-cation, salt-bridge, halogen, water-bridge) per mutation. |
| `Fig3_plip_loss_conservation.png/.svg` | 16-residue loss conservation heatmap across the 4 top-tier resistance hits. TYR849 lost in 4/4; CYS727 + PHE730 lost in 3/4. |
| `Fig4_score_vs_fingerprint_correlation.png/.svg` | 4-panel figure: (A) ΔS vs residues lost (r=0.52), (B) pose RMSD vs residues lost (r=0.93), (C) loss distribution boxplot per mutation, (D) verdict distribution stacked bar. |
| `Fig5_flagship_pymol_montage.png` | 2×2 montage of the flagship hit (C727R × HRO761 in 9S18): WT vs mutant custom PyMOL 3D views on top, PLIP native 3D views on bottom. |

## Tables (`tables/`)

| File | Rows | Columns | Description |
|---|---|---|---|
| `plip_interaction_summary.csv` | 68 | 14 | Interaction counts per complex (H-bond, hydrophobic, π-stack, π-cation, salt-bridge, halogen, water-bridge), total, interacting residues, n_residues_interacting |
| `plip_wt_vs_mutant_comparison.csv` | 57 | 10 | WT-vs-mutant fingerprint diff — n_lost_plip, n_retained_plip, n_gained_plip, lost_residues, gained_residues |
| `canonical_mapping_report.csv` | 68 | ~6 | Canonical WRN Q14191 residue mapping verification per complex |

## Per-complex figure sets

For every one of the 68 complexes, three complementary views are provided:

**1. 2D LigPlot-style (`01_2d_ligplot_diagrams/<complex>.png/.svg`)**
Central ligand box + interacting residues arranged in a circle, colored by chemistry
(positive/negative/polar/hydrophobic/aromatic). Interaction lines colored by type
(H-bond blue solid, hydrophobic green dotted, π-stack orange dashed, etc.). Distance
annotations on each contact. Publication-clean; SVG is fully editable.

**2. Custom PyMOL 3D annotated (`02_pymol_3d_annotated/<complex>.png`)**
1200×900 ray-traced 3D binding-site view. Protein rendered as transparent grey cartoon,
ligand in orange sticks with heteroatom coloring, interacting residues as sticks colored
by chemistry. Interaction dashes colored by type. One-letter residue labels
(e.g., F730, Y849).

**3. PLIP native 3D (`03_plip_native_3d/<complex>.png`)**
660×474 PyMOL binding-site render generated directly by PLIP command-line output.

## Ordering convention

Complexes are named `<mutation>_<template>_<ligand>[<_cov>]_complex`, e.g.:
- `WT_9S18_HRO761` — wild-type protein, 9S18 template, HRO761 ligand
- `C727R_9MJT_VVD-214_cov` — C727R mutant, 9MJT template, VVD-214 in covalent-attached form
- `NEG_9S19_WT_HRO761` — negative control (WRN 9S19 off-target site)

Ordering in Fig 1 & Fig 4C (mutations by fingerprint disruption, descending): C727R → C727S → C727A → G729D → L528S → I852F → F730L.

## Reproducibility

**PLIP command**: `python3 -m plip.plipcmd -f <complex>.pdb -o <out_dir> -t --xml -p`
- PLIP v3.0.0 (Schake et al., NAR 2025 gkaf361)
- PyMOL 3.2.0a for 3D rendering
- Geometric criteria: H-bond ≤3.5 Å + ≤120°; hydrophobic ≤4 Å; π-stack ≤5.5 Å; halogen ≤4 Å + ≤140°

**Canonical numbering**: Biopython PairwiseAligner (global, match=+2, mismatch=−3, gap_open=−10, extend=−0.5). Mismatch at mutation position accepted. Per-template C727 canonical mapping:
- 7GQU: C727 → pdb_pos 212
- 9MJT: C727 → pdb_pos 228
- 9S18: C727 → pdb_pos 227

Renumbered PDBs in `supplementary_pdb/` can be used to rerun PLIP or any other
interaction-analysis tool with canonical Q14191 numbering.

## Key findings (paper-ready)

1. **Fingerprint loss strongly correlates with pose displacement** — Pearson r = 0.93 (p = 7.3 × 10⁻²⁵, n = 57) between pose_RMSD_vs_WT and n_residues_lost. See Fig 4B.

2. **Fingerprint loss correlates moderately with docking penalty** — Pearson r = 0.52 (p = 3.6 × 10⁻⁵) between ΔS and n_residues_lost. See Fig 4A.

3. **Top-4 hits share TYR849 loss (4/4)** — This aromatic residue anchors HRO761/VVD-214 via π-stacking with the ligand quinoline system; its loss is the most conserved consequence across all top-tier resistance mutations.

4. **Per-mutation mean residues lost** (from Fig 1):
   - C727R: 3.56
   - C727S: 2.67
   - C727A: 2.67
   - G729D: 0.89
   - L528S: 0.33
   - I852F: 0.22
   - F730L: 0.11

5. **Verdict tiering validated** (Fig 4D):
   - C727R: 6/9 resistance
   - C727S / C727A: 4/6 resistance each
   - G729D: 4/9 resistance
   - L528S: 2/9 resistance
   - I852F: 0/9 resistance
   - F730L: 1/9 resistance


## Repo-tracked subset

This git-tracked copy excludes two heavy directories to keep the repository lean:

- `02_pymol_3d_annotated/` (32 MB, 68 PNG) — regeneratable from `supplementary_pdb/` via `phase5_docking_analysis/scripts/render_pymol_3d.py`
- `supplementary_pdb/` (23 MB, 68 PDB) — already tracked under `phase5_docking_analysis/plip_interaction_analysis/canonical_pdbs/`

The full 64 MB bundle including all three view types + supplementary PDBs is available in the session results panel.
