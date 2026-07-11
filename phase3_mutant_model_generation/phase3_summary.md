# Phase 3 Summary — Mutant Model Generation

**Project:** Mutation- and Conformational-State-Resolved Computational Atlas of WRN Helicase Inhibitor Resistance in MSI-High Cancers
**Phase:** 3 (mutant model generation)
**Date:** 2026-07-11

---

## What was done

Generated in silico mutant models for all 7 Phase 1 resistance mutations across 4 conformational-state templates, producing 32 prepared PDB structures (4 WT + 28 mutants). Each structure was processed through PDBFixer: mutation application, missing-atom reconstruction, and hydrogen addition at pH 7.0. Every mutation was verified by checking the residue identity at the target position after processing.

## Templates selected

| Template | State | Resolution | Chain | Ligand | Rationale |
|---|---|---|---|---|---|
| 9MJT | Apo | 1.73 Å | A | None | Best apo WT reference; no ligand-induced conformational bias |
| 9S18 | HRO761-bound | 1.995 Å | A | YHC (HRO761) | Mutation-free alternative to 8PFO (which has 6 engineered surface mutations); captures non-covalent inhibitor-bound pocket |
| 7GQU | VVD-214 covalent | 1.54 Å | A | X1L (covalent adduct) | Only public VVD-214 covalent cocrystal; captures covalent inhibitor-bound pocket |
| 9S19 | DNA-bound | 2.3 Å | B | DNA polynucleotide | Only DNA-bound structure; captures on-DNA conformational state |

**Why 9S18 over 8PFO:** 8PFO (1.90 Å) has 6 engineered surface mutations (E625A, R564A, R785A, R803A, E886A, R942A) per mmCIF `struct_ref_mut` records. 9S18 is mutation-free — a cleaner WT reference for a resistance atlas.

## Mutations modeled

All 7 Phase 1 resistance mutations:

| Mutation | WT residue | Position | Mutant residue | 3-letter code |
|---|---|---|---|---|
| L528S | LEU | 528 | SER | LEU-528-SER |
| C727A | CYS | 727 | ALA | CYS-727-ALA |
| C727S | CYS | 727 | SER | CYS-727-SER |
| C727R | CYS | 727 | ARG | CYS-727-ARG |
| G729D | GLY | 729 | ASP | GLY-729-ASP |
| F730L | PHE | 730 | LEU | PHE-730-LEU |
| I852F | ILE | 852 | PHE | ILE-852-PHE |

## C727 covalent handling

- **C727A/S/R on 7GQU:** X1L covalent ligand removed before mutation (covalent bond to Cys727 is physically impossible after mutation). Gives VVD-214 conformational state pocket geometry without the covalent bond. Files named `7GQU_C727A_nolig.pdb`, `7GQU_C727S_nolig.pdb`, `7GQU_C727R_nolig.pdb`.
- **Non-C727 mutations on 7GQU (L528S, G729D, F730L, I852F):** X1L ligand kept. C727 covalent bond remains intact since C727 is not mutated.
- **All mutations on 9MJT, 9S18, 9S19:** Standard mutagenesis (no covalent ligand involved).

## Structures generated

| Category | Count | Location |
|---|---|---|
| WT prepared templates | 4 | `prepared_wt_templates/` |
| Mutant models (standard) | 25 | `mutant_models/` |
| Mutant models (C727, ligand-removed) | 3 | `mutant_models/` |
| **Total** | **32** | |

## Tool used

**PDBFixer** (OpenMM ecosystem):
- `applyMutations(["CYS-727-ALA"], chain_id)` — 3-letter code amino acid substitution
- `findMissingResidues()` + `findMissingAtoms()` + `addMissingAtoms()` — side-chain reconstruction
- `addMissingHydrogens(7.0)` — protonation at pH 7.0
- `removeHeterogens(keepWater=False)` — ligand removal for C727 mutations on 7GQU

**gemmi** for mmCIF → PDB format conversion.

## Main limitations

1. **Side-chain conformations are not energy-minimized.** PDBFixer uses PDB template-based reconstruction, not rotamer optimization or force-field minimization. MD remains on hold per project directive. These models are suitable for static structural comparison (pocket geometry, residue positions) but not for detailed energetic analysis.
2. **No backbone relaxation.** Mutations that introduce steric clash (e.g., C727R, G729D) may have unrealistic local geometry without backbone adjustment. This is a known limitation of template-based mutagenesis without minimization.
3. **9S19 processing time.** The DNA-bound structure (chain B, 409 residues + DNA chains) took significantly longer (~90-210s per model) due to the larger system size and DNA chains.
4. **8PFO not used as primary template.** 8PFO (1.90 Å, higher resolution than 9S18) has 6 engineered surface mutations. While none coincide with the 5 resistance residues, 9S18 was chosen as the mutation-free alternative. 8PFO remains available as an alternative if ChatGPT/user prefers higher resolution.

## What should happen in Phase 4

Phase 4 (pocket geometry analysis) should:
- Compare WT vs mutant pocket volumes, shapes, and key residue positions across the 4 conformational states
- Quantify the structural perturbation caused by each mutation at each position
- Identify which mutations most significantly alter the HRO761 vs VVD-214 binding pockets
- Use the 32 models generated here as input

## What should NOT happen yet

- **Docking** — planned for Phase 5, not Phase 3 or 4
- **Molecular dynamics** — remains on hold per project directive
- **Virtual screening** — not part of this project's scope
- **Binding-affinity claims** — not to be made without experimental grounding
- **Energy minimization** — would require force field setup bordering on MD preparation; deferred
