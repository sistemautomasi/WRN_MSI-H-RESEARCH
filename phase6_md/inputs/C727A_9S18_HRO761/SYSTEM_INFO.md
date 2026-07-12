# C727A_9S18_HRO761 — MD input

## Source
Phase 5 Vina docking complex.

## System composition
- Protein: WRN helicase domain (chain A, C727A mutation)
- Ligand: HRO761 (Novartis WRN inhibitor)
- Template: 9S18 (HRO761 design pocket, Ferretti 2024)
- Docking mode: non-covalent
- Best score: -13.370 kcal/mol
- ΔScore vs WT: +0.170 kcal/mol
- Pose RMSD vs WT: 1.41 Å
- Contacts lost vs WT: 3 residues
- Verdict: resistance
- Criteria met (composite 3-of): 1/3

## Role in Phase 6
**Negative control** — mutation at the same position (Cys727) but predicted
neutral for HRO761 by Phase 5 (composite verdict = neutral, criteria met = 0/3).
Provides the third arm of the A/B/C causality test: if MD backbone RMSD and
ligand stability are equivalent to WT here but diverge for C727R, the C727R signal
is specifically driven by the steric-blockade geometry, not by generic
Cys727-perturbation.

## SMILES
See `ligand.smi` — canonical from PubChem CID 166140536.

## Files
- `complex.pdb` — verbatim from Phase 5
- `protein.pdb` — chain A only (protein atoms)
- `ligand.pdb` — chain L LIG residue only
- `ligand.smi` — canonical SMILES for parameterisation
