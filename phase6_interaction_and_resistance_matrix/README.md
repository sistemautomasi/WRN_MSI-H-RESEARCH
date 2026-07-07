# Phase 6 — Interaction and Resistance Matrix

## Objective

Build a per-mutation × per-inhibitor resistance matrix integrating structural, docking, and literature evidence.

## Status

**Not started**

## Expected Approach

- Cross-reference Phase 1 literature resistance data with Phase 4 pocket geometry and Phase 5 docking
- Classify each mutation × inhibitor pair: resistant / sensitive / partial / unknown
- Identify chemotype-specific resistance patterns (HRO761 vs VVD-214)
- Flag mutations with structural hypothesis but no experimental data

## Expected Outputs

- `resistance_matrix.csv` — Mutation × inhibitor classification
- `resistance_heatmap.png`
- `chemotype_specificity_analysis.md`
- `phase6_summary.md`
