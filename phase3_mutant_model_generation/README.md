# Phase 3 — Mutant Model Generation

## Objective

Generate structural models of WRN helicase resistance mutations (L528S, C727A, C727S, C727R, G729D, F730L, I852F) on selected WT template structures from Phase 2.

## Status

**Pending user authorization**

## Expected Approach

- Select WT templates from Phase 2 (best apo, best HRO761-bound, best VVD-214-bound)
- Introduce mutations via side-chain replacement + local relaxation
- For covalent inhibitors: model C727A/S/R as loss of covalent handle
- Preserve conformational state of template (apo / inhibitor-bound / nucleotide-bound)

## Expected Outputs

- `mutant_models/` — PDB/mmCIF files for each mutation × template combination
- `mutation_model_log.csv` — Template, mutation, method, relaxation protocol, energy
- `phase3_summary.md`
- `phase3_user_verification_checklist.md`

## Boundary Conditions

- No MD simulations (environment limitation)
- No binding affinity claims
- Models are hypotheses, not experimental structures
