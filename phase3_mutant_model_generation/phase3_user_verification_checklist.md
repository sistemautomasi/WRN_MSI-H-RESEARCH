# Phase 3 User Verification Checklist

**Purpose:** Items for the user to verify before authorizing Phase 4 (pocket geometry analysis).

---

## A. Template selection

- [ ] **9MJT** (apo, 1.73 Å, chain A) is acceptable as the apo WT reference template.
- [ ] **9S18** (HRO761-bound, 1.995 Å, chain A, mutation-free) is acceptable as the HRO761-bound template. Confirm that choosing 9S18 over 8PFO (higher resolution but 6 engineered mutations) is acceptable.
- [ ] **7GQU** (VVD-214 covalent, 1.54 Å, chain A, X1L ligand) is acceptable as the VVD-214 covalent template.
- [ ] **9S19** (DNA-bound, 2.3 Å, chain B) is acceptable as the DNA-bound template.

## B. Mutation panel

- [ ] All 7 Phase 1 mutations are modeled: L528S, C727A, C727S, C727R, G729D, F730L, I852F.
- [ ] No mutations were skipped or added beyond the Phase 1 panel.

## C. C727 covalent handling

- [ ] For C727A/S/R on 7GQU: X1L ligand was removed before mutation. This is acceptable.
- [ ] For non-C727 mutations on 7GQU (L528S, G729D, F730L, I852F): X1L ligand was kept. This is acceptable.

## D. File inventory

- [ ] 4 WT prepared PDB files exist in `prepared_wt_templates/`.
- [ ] 28 mutant PDB files exist in `mutant_models/`.
- [ ] `mutant_model_inventory.csv` loads cleanly with 32 rows × 14 columns.
- [ ] All 32 models have `verification_status = verified`.

## E. Method limitations

- [ ] Side-chain conformations are PDBFixer template-based reconstructions, NOT energy-minimized. This is acceptable for Phase 4 pocket geometry comparison.
- [ ] No backbone relaxation was performed. This is acceptable.
- [ ] No MD, no docking, no energy minimization, no virtual screening, no binding-affinity prediction was performed.

## F. Boundary conditions

- [ ] Confirm: no MD was performed.
- [ ] Confirm: no docking was performed.
- [ ] Confirm: no binding-affinity claims were made.
- [ ] Confirm: Phase 4-7 folders were not modified.
- [ ] Confirm: no forbidden file types (.pdbqt, .tpr, .gro, .top, .mdp, .dcd, .xtc, .trr) were created.

## G. Next steps

- [ ] After verification, Phase 4 (pocket geometry analysis) can be authorized.
- [ ] Phase 4 should compare WT vs mutant pocket volumes, shapes, and key residue positions across the 4 conformational states.
- [ ] Docking remains deferred to Phase 5.
- [ ] MD remains on hold per project directive.
