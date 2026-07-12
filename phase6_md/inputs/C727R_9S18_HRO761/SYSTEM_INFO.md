# C727R_9S18_HRO761 — MD input

## Source
Phase 5 Vina docking complex.

## System composition
- Protein: WRN helicase domain (chain A, C727R mutation)
- Ligand: HRO761 (Novartis WRN inhibitor)
- Template: 9S18 (HRO761 design pocket, Ferretti 2024)
- Docking mode: non-covalent
- Best score: -7.327 kcal/mol
- ΔScore vs WT: +6.210 kcal/mol
- Pose RMSD vs WT: 11.12 Å
- Contacts lost vs WT: 13 residues
- Verdict: resistance
- Criteria met (composite 3-of): 3/3

## Role in Phase 6
**Top-hit system** — largest resistance signal in Phase 5 (all 3 criteria met).
Test whether the docked C727R displaced pose is *dynamically stable*, and whether
the 13-residue contact loss persists over 100 ns MD.

## SMILES
See `ligand.smi` — canonical from PubChem CID 166140536.

## Files
- `complex.pdb` — verbatim from Phase 5
- `protein.pdb` — chain A only (protein atoms)
- `ligand.pdb` — chain L LIG residue only
- `ligand.smi` — canonical SMILES for parameterisation
