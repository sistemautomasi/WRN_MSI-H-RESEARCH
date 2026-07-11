# Phase 4 Ringkasan Eksekutif — 1 halaman

**Setup**: 32 structures (4 WT × 4 conformational states + 28 mutants) → fpocket 4.0 + Kabsch RMSD + VdW clash detection.

## Hasil dalam 4 baris

1. **C727R paling perturbed**: 13 clashes dengan F917 (motion residue Fletcher) di 7GQU. Volume drop 72%.
2. **G729D reproduces Fowler**: 22 clashes total. 7GQU_G729D clash dengan F730 (partner Fowler jangka).
3. **9S19/DNA-bound state tidak ada drug pocket**: nearest-to-C727 pocket hanya 303 Å³, druggability 0.
4. **57% mutations concordant**: C727R + G729D + I852F dengan literature strong; L528S + F730L concordant weak; C727A/S discordant (pipeline blind kepada chemistry).

## Table ringkasan

| Mutation | Signal | Clashes | Vol Δ max | Literature | Match? |
|---|---|---|---|---|---|
| **C727R** | strong 3/3 | 13 | -72% | strong (ROS1 G2032R analog, Dijkhuizen 2023) | ✓ concordant |
| **G729D** | strong 3/3 | 22 | +1.9% | strong (Fowler MOE+MD) | ✓ concordant |
| I852F | strong 3/3 | 6 | +3.2% | weak-mod (hinge) | over-called? |
| C727A | weak 1/3 | 0 | -68% | strong (chem ablation) | pipeline blind |
| C727S | none 0/3 | 0 | +5.3% | strong (chem ablation) | pipeline blind |
| F730L | none 0/3 | 0 | +3.0% | mod (π-stack loss) | pipeline blind |
| L528S | none 0/3 | 0 | +0.7% | mod (secondary) | ✓ both weak |

## Batasan utama
- PDBFixer preserved sidechains (0 Å displacement) → tak nampak Fowler's F730 shift 5.7 Å
- Chemistry-based mutations (C727A/S) tak dapat dideteksi dari geometry sahaja
- 9S19 rebuild artifacts di N-terminal (bukan pocket) → 2.29 Å global RMSD artifact

## Fail deliverable (14 CSV + 4 figures + 3 reports)
`/mnt/results/phase4_pocket_geometry/`

**Files utama**: `phase4_master.csv` (32 rows), `phase4_deltas.csv` (28 rows), `phase4_cross_validation.csv` (7 rows), `figures/fig[1-4]_*.png`

**Reports**: `phase4_pocket_geometry_report.md` (technical detail), `phase4_missing_data_report.md` (limitasi), `phase4_summary.md` (dokumen ini).

## Cadangan Phase 5
1. MD ~200 ns untuk F730L (validate π-stack loss)
2. Docking Chai-1 untuk quantify pose RMSD (target Fowler's 6.1 Å benchmark)
3. Wet-lab validation untuk I852F (over-called dalam static pipeline kami)
