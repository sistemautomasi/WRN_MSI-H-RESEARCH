# WT_9S18_HRO761 — MD input

## Source
Phase 5 Vina docking complex.

## System composition
- Protein: WRN helicase domain (chain A, no mutation)
- Ligand: HRO761 (Novartis WRN inhibitor)
- Template: 9S18 (HRO761 design pocket, Ferretti 2024)
- Docking mode: non-covalent
- Best score: -13.54 kcal/mol
- Verdict: reference-wt (baseline)

## Role in Phase 6
**Baseline control** — establishes the equilibrium binding mode of HRO761 at its
design pocket. Reference for RMSD/RMSF/contact drift of the mutant systems.

## SMILES
See `ligand.smi` — canonical from PubChem CID 166140536.

## Files
- `complex.pdb` — verbatim from Phase 5
- `protein.pdb` — chain A only (protein atoms)
- `ligand.pdb` — chain L LIG residue only
- `ligand.smi` — canonical SMILES for parameterisation
