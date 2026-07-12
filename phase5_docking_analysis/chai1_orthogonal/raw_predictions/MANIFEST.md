# Chai-1 Raw Predictions Manifest

11 subfolders — 10 mapped Phase 5 systems + 1 endpoint smoke test.

Each subfolder contains:
- `pred.model_idx_{0..4}.cif` — 5 predicted structures
- `scores.model_idx_{0..4}.npz` — per-model Chai-1 scores (ipTM, pTM, clash)
- `_metadata.json` — HPC job id + system parameters

## Mapping table (hpc_<uuid> → system)

| System | Mutation | Template | Ligand | Covalent | MSA | HPC job |
|---|---|---|---|---|---|---|
| C727A_9MJT_VVD-214_cov | C727A | 9MJT | VVD-214 | True | no_msa | `70cd0b80` |
| C727R_9MJT_VVD-214 | C727R | 9MJT | VVD-214 | False | no_msa | `c0589c45` |
| C727R_9S18_HRO761 | C727R | 9S18 | HRO761 | False | no_msa | `20931f65` |
| C727S_9MJT_VVD-214 | C727S | 9MJT | VVD-214 | False | no_msa | `c0424c99` |
| C727S_9MJT_VVD-214_cov | C727S | 9MJT | VVD-214 | True | no_msa | `273daa8e` |
| F730L_9MJT_VVD-214 | F730L | 9MJT | VVD-214 | False | no_msa | `d95c0cec` |
| G729D_9MJT_VVD-214 | G729D | 9MJT | VVD-214 | False | no_msa | `6065d113` |
| L528S_9MJT_VVD-214 | L528S | 9MJT | VVD-214 | False | no_msa | `83be1602` |
| WT_9MJT_VVD-214 | WT | 9MJT | VVD-214 | False | no_msa | `53e7facc` |
| WT_9S18_HRO761 | WT | 9S18 | HRO761 | False | no_msa | `23eb895a` |

## Smoke test

`_smoke_test_ubiquitin_20260712/` — ubiquitin (76 aa) protein-only fold, submitted 2026-07-12T05:27:49 to verify Chai-1 endpoint availability before submitting full Phase 5 batch. NOT part of Phase 5 analysis.
