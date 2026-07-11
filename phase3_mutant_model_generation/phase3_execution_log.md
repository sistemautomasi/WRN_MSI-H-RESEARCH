# Phase 3 Execution Log

**Date:** 2026-07-11
**Phase:** 3 (mutant model generation)

---

## Search sources and tools used

- **RCSB PDB mmCIF files** — 4 template structures from Phase 2 `protein_structure_files/`
- **gemmi** — mmCIF to PDB format conversion, covalent connection clearing
- **PDBFixer** (OpenMM) — in silico mutagenesis, missing atom reconstruction, hydrogen addition
- **BioPython** — structure validation (available, used for chain/residue verification)
- **pandas** — inventory CSV generation and verification

## Pre-execution audit (10 checks, all passed)

Before generating any models, the following claims were verified against actual data:

1. **Template resolutions** — 9MJT 1.73 Å, 9S18 1.995 Å, 7GQU 1.54 Å, 9S19 2.3 Å (from `structure_inventory.csv`)
2. **All 5 resistance residues present** in all 4 templates (from `structure_inventory.csv`)
3. **Chain IDs** — 9MJT chain A, 9S18 chain A, 7GQU chain A, 9S19 chain B (from `residue_mapping_table.csv`)
4. **9S18 mutation-free** — `_entity.pdbx_mutation` = `?`, 0 `struct_ref_mut` records (from mmCIF)
5. **7GQU covalent ligand** — CCD X1L, covalent distance 1.820/1.807 Å (from `structure_inventory.csv`)
6. **PDBFixer pipeline** — end-to-end test on 9MJT: C727A mutation verified, missing atoms added, hydrogens added
7. **7GQU ligand removal** — `removeHeterogens` removes X1L, C727A mutation verified on ligand-stripped structure
8. **9S19 chain B** — mutation on chain B verified (C727A → ALA at position 727)
9. **7GQU ligand kept** — F730L mutation with X1L retained, C727 remains CYS
10. **All 7 mutation codes** — L528S, C727A, C727S, C727R, G729D, F730L, I852F all produce correct residue at target position

## Files created

### prepared_wt_templates/ (4 files)

| File | Size | Processing time |
|---|---|---|
| 9MJT_WT_prepared.pdb | 611 KB | 19.4s |
| 9S18_WT_prepared.pdb | 620 KB | 3.5s |
| 7GQU_WT_prepared.pdb | 614 KB | 17.3s |
| 9S19_WT_prepared.pdb | 1.2 MB | 281.7s |

### mutant_models/ (28 files)

| Template | Mutations | Sizes | Times |
|---|---|---|---|
| 9MJT | L528S, C727A, C727S, C727R, G729D, F730L, I852F | 590-592 KB each | 1.1-3.7s each |
| 9S18 | L528S, C727A, C727S, C727R, G729D, F730L, I852F | 595-596 KB each | 1.0-3.8s each |
| 7GQU | L528S, G729D, F730L, I852F (ligand kept) | 590-591 KB each | 1.2-2.2s each |
| 7GQU | C727A, C727S, C727R (ligand removed) | 532-533 KB each | 1.0-1.5s each |
| 9S19 | L528S, C727A, C727S, C727R, G729D, F730L, I852F | 1.2 MB each | 88-207s each |

### CSV and markdown

| File | Description |
|---|---|
| mutant_model_inventory.csv | 32 rows × 14 columns |
| phase3_summary.md | Human-readable summary |
| phase3_execution_log.md | This file |
| phase3_missing_data_report.md | Limitations and data-quality notes |
| phase3_user_verification_checklist.md | User verification items |
| PHASE_HANDOFF_FOR_CHATGPT.md | Handoff for ChatGPT review |

## Processing pipeline (per structure)

1. Read mmCIF from Phase 2 `protein_structure_files/` using gemmi
2. If C727 mutation on 7GQU: clear covalent connections, convert to PDB, load PDBFixer, `removeHeterogens(keepWater=False)`
3. Otherwise: convert mmCIF to PDB using gemmi, load PDBFixer
4. `applyMutations([mutation_code], chain_id)` — substitute residue
5. `findMissingResidues()` — identify gaps
6. `findMissingAtoms()` — identify missing side-chain atoms
7. `addMissingAtoms()` — reconstruct missing atoms from templates
8. `addMissingHydrogens(7.0)` — add hydrogens at pH 7.0
9. Write PDB file
10. Verify: check residue identity at mutation position matches expected

## Assumptions

1. PDBFixer `applyMutations` produces adequate side-chain conformations for static structural analysis (not energy-minimized). Sufficient for Phase 4 pocket geometry comparison.
2. Auth_seq_id in mmCIF files matches UniProt Q14191 canonical numbering (verified in Phase 2).
3. Chain A is the WRN chain for 9MJT, 9S18, 7GQU; chain B for 9S19 (verified in Phase 2).
4. Removing X1L from 7GQU for C727 mutations preserves the protein backbone conformational state.
5. pH 7.0 for protonation states (standard for structural biology).
6. No energy minimization (MD is on hold; minimization would require force field setup).

## Warnings

- **9S19 processing time:** The DNA-bound structure took significantly longer per model (~90-210s) due to larger system size (chain B 409 residues + DNA chains C/D). Total 9S19 time was ~22 minutes for 8 structures.
- **Side-chain quality:** PDBFixer uses template-based reconstruction, not rotamer optimization. For mutations introducing large steric changes (C727R, G729D), local geometry may be unrealistic without minimization. This is documented as a limitation.
- **9OG8 excluded:** The 9OG8 structure (1.428 Å anomalous covalent bond) was not selected as a template. The bond distance anomaly documented in Phase 2 §3 remains unresolved.

## Stop condition confirmation

- 32 PDB structures generated (4 WT + 28 mutants)
- All mutations verified at residue level
- No docking files created
- No MD files created
- No mutant models beyond the 4 selected templates
- Phase 4-7 folders not modified
- No binding-affinity claims made
