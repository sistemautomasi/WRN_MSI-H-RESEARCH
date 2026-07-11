# Phase 4 — Pocket Geometry Analysis

## Status
**COMPLETE** (7 July 2026)

## Objective
Quantify how 7 resistance mutations (L528S, C727A, C727S, C727R, G729D, F730L, I852F) reshape the inhibitor-binding pocket across 4 WRN conformational states (9MJT apo, 9S18 HRO761-bound, 7GQU VVD-214-bound, 9S19 DNA-bound).

## Approach
- **Setup**: canonical UniProt Q14191 numbering + offset table (WT: -499 to -515, mutant: -516 to -526 per template) + template-specific anchors (C727 SG, ligand centroids)
- **fpocket 4.0**: 32 structures × ~24-70 pockets each; target pocket = nearest-to-anchor
- **Per-residue geometry**: Cα distances, χ1 dihedrals, VdW clashes over 15 pocket-lining residues
- **Kabsch RMSD**: WT-vs-mutant global + pocket-local; WT-vs-WT baseline
- **Verdict rule**: perturbed if |Δvol|>10% OR n_clashes>0 OR pocket_RMSD>1.0 Å
- **Cross-validation**: 3 druggable states (9MJT, 9S18, 7GQU); 9S19 excluded from signal-counting (low-drug baseline)

## Results Summary

### WT baseline pocket volumes
| Template | Volume (Å³) | Druggability |
|----------|-------------|--------------|
| 9MJT (apo) | 1207 | 0.871 |
| 9S18 (HRO761) | 1570 | 0.941 |
| 7GQU (VVD-214) | 1291 | 0.908 |
| 9S19 (DNA drug pocket) | 303 | 0.000 |

### Cross-validation with wet-lab literature
| Mutation | Our signal | Literature | Concordance |
|----------|------------|------------|-------------|
| **C727R** | strong 3/3 (13 clashes) | strong (ROS1 G2032R analog) | ✓ concordant |
| **G729D** | strong 3/3 (22 clashes) | strong (Fowler 2026 MOE+MD) | ✓ concordant |
| I852F | strong 3/3 (6 clashes) | weak-moderate | our signal higher |
| C727A | weak 1/3 (0 clashes) | strong (covalent ablation) | pipeline blind |
| C727S | no signal | strong (covalent ablation) | DISCORDANT |
| F730L | no signal | moderate (hydrophobic contact loss) | partial |
| L528S | no signal | moderate | partial |

## Key Files
- `phase4_master.csv` — 32 rows × 20 cols per-structure metrics + verdict
- `phase4_deltas.csv` — 28 rows mutant vs WT deltas
- `phase4_cross_validation.csv` — signal vs literature comparison
- `phase4_9S19_dual_pocket.csv` — 9S19 ATP + drug pocket dual analysis (transparency)
- `vdw_clashes_full.csv` — 41 atom-pair clashes (full enumeration, no truncation)
- `pocket_rmsd.csv` — 34 Kabsch RMSDs (28 WT-mut + 6 WT-WT baseline)
- `pocket_residue_geometry.csv` — 480 per-residue rows
- `figures/fig[1-4]_*.png|svg` — 4 figures × 2 formats

## Reports (Bahasa Melayu)
- `phase4_pocket_geometry_report.md` — technical detail (~18KB)
- `phase4_missing_data_report.md` — pipeline limitations
- `phase4_summary.md` — 1-page executive
- `phase4_verification_checklist.md` — self-audit

## Key Limitations
1. **PDBFixer preserved sidechains** (0 Å terminal displacement in 392/392 non-mutation records) → Fowler's F730 shift 5.7 Å not reproducible
2. **Chemistry-based mutations** (C727A/S covalent ablation) not detectable from geometry alone
3. **9S19 rebuild artifacts** at N-terminal (Phase 3 origin, outside pocket)
4. **9S19 drug pocket "collapse"** is biological (DNA-bound state), not artifact — Fletcher 2026 confirms conformationally distinct on-DNA state

## Verified against transcript.jsonl
All external citations (Fowler DOI 10.1158/1535-7163.mct-25-0666, Fletcher DOI 10.1038/s42003-026-09584-0, Baltgalvis DOI 10.1038/s41586-024-07318-y, Ferretti DOI 10.1038/s41586-024-07350-y, Kikuchi DOI 10.1021/acs.jmedchem.5c01805, Dijkhuizen DOI 10.1016/j.annonc.2023.09.1557, F730S 93% AF, T705A 87% AF, MOE Protein Builder, 900 ns GROMACS MD, D729-T573 H-bond, F730 5.7 Å shift, ligand pose RMSD 6.1 Å) cross-checked via `rg` on transcript file.

Report author: Biomni (Phylo AI)
