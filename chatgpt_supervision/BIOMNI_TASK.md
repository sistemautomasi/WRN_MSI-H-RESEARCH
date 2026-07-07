# Biomni Task: Phase 2 Post-Completion Review Handoff

## Task title

Phase 2 Post-Completion Review Handoff

## Objective

Prepare the Phase 2 outputs for ChatGPT verification by assembling structured handoff documents in `chatgpt_supervision/`. No scientific analysis is performed in this task — only documentation of what was produced, what remains open, and what ChatGPT needs to review.

## Authorized phase

**Phase 2 review only.**

This task is scoped to preparing review-handoff documentation for the already-completed Phase 2. No new phase work is authorized.

## Input files read

The following files were read before preparing this handoff:

1. `README.md` (repo root)
2. `chatgpt_supervision/README.md` (created in this task)
3. `chatgpt_supervision/BIOMNI_RUN_INSTRUCTIONS.md` (provided by user/ChatGPT at session start)
4. `phase2_structure_ligand_collection/phase2_summary.md`
5. `phase2_structure_ligand_collection/phase2_missing_data_report.md`
6. `phase2_structure_ligand_collection/structure_inventory.csv`
7. `phase2_structure_ligand_collection/residue_mapping_table.csv`
8. `phase2_structure_ligand_collection/ligand_inventory.csv`

## Planned output

Supervision handoff files only, all inside `chatgpt_supervision/`:

- `README.md` — folder index and role definitions
- `BIOMNI_TASK.md` — this file
- `BIOMNI_OUTPUT_SUMMARY.md` — summary of Phase 2 outputs
- `OPEN_QUESTIONS_FOR_CHATGPT.md` — 14 issues requiring ChatGPT review
- `NEXT_ACTION_RECOMMENDATION.md` — Biomni's recommendation on approval and next steps
- `DECISION_LOG.md` — short entry recording handoff preparation
- `CHATGPT_REVIEW.md` — empty placeholder for ChatGPT to fill

## Out of scope

The following are explicitly out of scope for this task and will NOT be performed:

- **Phase 3** — no mutant model generation, no template selection for modeling
- **Mutant modeling** — no L528S / C727A / C727S / C727R / G729D / F730L / I852F models
- **Docking** — no docking of any inhibitor to any structure
- **Molecular dynamics** — no MD simulations, no MD system preparation (MD remains on hold per project directive)
- **Virtual screening** — no screening of any compound library
- **Binding-affinity claims** — no prediction or statement of binding affinity

## Stop condition

Stop after updating the supervision files in `chatgpt_supervision/`, committing, and pushing to GitHub. Do not proceed to Phase 3. Do not modify Phase 1 or Phase 2 science outputs. Do not modify Phase 3-7 folders.

End with:

```
Phase 2 handoff prepared. Please ask ChatGPT to review the GitHub repository before proceeding.
```
