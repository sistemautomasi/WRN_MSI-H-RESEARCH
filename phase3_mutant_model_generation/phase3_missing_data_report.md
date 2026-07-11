# Phase 3 Missing Data, Limitations, and Data-Quality Notes

**Purpose:** Document all limitations, assumptions, and data-quality issues in the Phase 3 mutant model generation.

---

## 1. Side-chain reconstruction without energy minimization

**Issue:** PDBFixer `applyMutations` + `addMissingAtoms` reconstructs side-chain atoms using PDB templates, not rotamer optimization or force-field minimization. The resulting side-chain conformations are reasonable for static structural comparison but may not represent the true energy-minimized geometry.

**Affected mutations:** All 28 mutant models. Most impactful for:
- **C727R** — introduces a large positively charged arginine where cysteine was; steric clash likely without backbone relaxation
- **G729D** — introduces a bulky negatively charged aspartate at a glycine hinge; backbone conformational change likely
- **I852F** — introduces a bulky aromatic phenylalanine; may clash with HRO761 pocket residues

**Implication for Phase 4:** Pocket geometry analysis should focus on backbone-level changes (CA positions, pocket volume) rather than detailed side-chain rotamer analysis. If side-chain-level analysis is needed, energy minimization or rotamer optimization should be performed first (deferred — MD is on hold).

## 2. No backbone relaxation

**Issue:** Template-based mutagenesis preserves the WT backbone coordinates. Mutations that cause local backbone movement (especially C727R, G729D) will have unrealistic local geometry.

**Implication:** The mutant models represent the "first-order" structural perturbation — the side-chain substitution on the WT backbone. This is a standard starting point for computational resistance analysis but is not a relaxed structure.

## 3. 8PFO not used as primary HRO761 template

**Issue:** 8PFO (1.90 Å, Ferretti et al. Nature 2024) is the highest-resolution HRO761 cocrystal but has 6 engineered surface mutations (E625A, R564A, R785A, R803A, E886A, R942A). 9S18 (1.995 Å, Fletcher et al. Commun Biol 2026) was chosen instead because it is mutation-free.

**Rationale:** For a resistance atlas, a mutation-free WT construct is a cleaner reference. None of the 8PFO engineered mutations coincide with the 5 resistance residues, so 8PFO could be used as an alternative if higher resolution is preferred.

**Implication:** If ChatGPT or the user prefers 8PFO, the same 7 mutations can be modeled on it in a follow-up. The Phase 2 `phase2_missing_data_report.md` §9 documents this choice.

## 4. 9OG8 excluded from template selection

**Issue:** 9OG8 (1.66 Å) has an anomalously short covalent bond distance (1.428 Å, S-C) documented in Phase 2 §3. It was not selected as a template.

**Implication:** 9OG8 is available in Phase 2 `protein_structure_files/` if needed, but the bond distance anomaly should be resolved (visual inspection or cross-check with Tong et al. 2025 J Med Chem) before use.

## 5. L528S modeling scope

**Issue:** L528 is absent in 6 of 37 Phase 2 structures due to polymer construct design. However, all 4 selected Phase 3 templates (9MJT, 9S18, 7GQU, 9S19) have L528 present, so L528S was modeled on all 4.

**Implication:** No gap. L528S is fully covered across all 4 conformational states.

## 6. C727 mutations on 7GQU: ligand removal

**Issue:** For C727A/S/R on the VVD-214 covalent template 7GQU, the X1L covalent ligand was removed before mutation. This means these 3 models represent the VVD-214 conformational state pocket without the covalent ligand.

**Rationale:** The covalent bond to Cys727 is physically impossible after C727 mutation. Removing the ligand preserves the protein backbone conformational state while removing the impossible covalent bond.

**Implication for Phase 4:** When comparing C727 mutant pockets on 7GQU, note that the ligand is absent. The pocket geometry reflects the apo-like state within the VVD-214 conformational context, not the ligand-bound state.

## 7. 9S19 DNA chains retained

**Issue:** 9S19 contains DNA chains (C and D) in addition to the WRN protein chain (B). These were retained in all 9S19 models. The DNA chains increase file size (~1.2 MB vs ~600 KB for other templates) and processing time.

**Rationale:** The DNA-bound conformational state is the defining feature of 9S19. Removing DNA would defeat the purpose of using this template.

## 8. No energy minimization performed

**Issue:** No force-field energy minimization was applied to any model. MD remains on hold per project directive.

**Implication:** All 32 structures are "raw" PDBFixer output. They are suitable for:
- Pocket volume/shape comparison (backbone-level)
- Residue position comparison (CA, CB positions)
- Visual inspection of mutation sites
- Preparation for future docking (with minimization as a preprocessing step)

They are NOT suitable for:
- Detailed energetic analysis
- Precise hydrogen-bond network analysis
- Binding-affinity estimation
- Any claim about "preferred" side-chain conformations

## 9. Hydrogen protonation states

**Issue:** Hydrogens were added at pH 7.0 using PDBFixer's default protonation state assignments. Histidine tautomer states are assigned by PDBFixer's internal rules, not by explicit pKa calculation.

**Implication:** For most residues at pH 7.0, this is adequate. For histidines near mutation sites or ligand pockets, explicit pKa calculation (e.g., PROPKA) may be needed in a later phase.
