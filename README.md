# WRN_MSI-H-RESEARCH

**Mutation- and Conformational-State-Resolved Computational Atlas of WRN Helicase Inhibitor Resistance in MSI-High Cancers**

## Project Overview

This repository contains the computational atlas for understanding how WRN helicase resistance mutations affect inhibitor binding, pocket geometry, structural state, and resistance patterns for HRO761 and VVD-133214 / VVD-214 / RO7589831 in MSI-high (microsatellite instability-high) cancers.

This is **not** a random virtual screening project. The focus is **resistance mechanism analysis**.

## Key Mutations

| Mutation | Residue Position | Type |
|---|---|---|
| L528S | 528 | Resistance hotspot |
| C727A | 727 | Covalent-handle loss |
| C727S | 727 | Covalent-handle loss |
| C727R | 727 | Covalent-handle loss |
| G729D | 729 | Pocket reshaping |
| F730L | 730 | Hydrophobic pocket |
| I852F | 852 | Pocket reshaping |

## Key Inhibitors

- **HRO761** — Novartis, non-covalent allosteric (clinical stage)
- **VVD-133214 / VVD-214 / RO-7589831** — Vividion/Roche, covalent allosteric at Cys727 (clinical stage)
- **GSK4418959 / IDE275** — GSK/IDEAYA, non-covalent reversible (clinical stage)
- **SNV5686** — sponsor not disclosed in AACR 2025 abstract 2921

## Repository Structure

```
WRN_MSI-H-RESEARCH/
├── phase1_literature_curation/              # Literature, mutation table, inhibitor table
├── phase2_structure_ligand_collection/      # Verified PDB + ligand inventory (37 structures)
├── phase3_mutant_model_generation/          # Mutant homology/covalent-adduct models
├── phase4_pocket_geometry_analysis/         # Pocket volume, shape, electrostatics
├── phase5_docking_analysis/                 # Docking of inhibitors to WT + mutant models
├── phase6_interaction_and_resistance_matrix/# Per-mutation × per-inhibitor resistance matrix
└── phase7_manuscript_outputs/               # Figures, tables, manuscript drafts
```

## Execution Policy

- **Phase-by-phase execution only** — each phase verified before proceeding
- **No MD simulations** (environment limitation)
- **No binding affinity claims** without experimental grounding
- **Every claim traceable** to a specific PDB structure, citation, or coordinate-level parse

## Current Status

| Phase | Status |
|---|---|
| Phase 1 — Literature Curation | Completed (separate session) |
| Phase 2 — Structure & Ligand Collection | **Completed** — 37 structures, 9 ligands, 185 residue mappings |
| Phase 3 — Mutant Model Generation | Pending user authorization |
| Phase 4 — Pocket Geometry Analysis | Not started |
| Phase 5 — Docking Analysis | Not started |
| Phase 6 — Interaction & Resistance Matrix | Not started |
| Phase 7 — Manuscript Outputs | Not started |

## License

Research data — pre-publication. All rights reserved.
