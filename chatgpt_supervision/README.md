# ChatGPT Supervision Workflow

This folder is the shared supervision layer between:

- **Biomni** — execution agent / runner
- **ChatGPT** — scientific reviewer, verifier, and phase-decision supervisor
- **GitHub** — shared project workspace and audit trail

## Purpose

Biomni can run technical work, generate files, parse databases, and prepare outputs. However, all scientific decisions, phase transitions, and uncertain claims must be reviewed before the project proceeds.

This folder prevents uncontrolled phase-jumping and reduces hallucination risk.

## Core rule

Biomni should not proceed to the next phase until the user explicitly authorizes it after ChatGPT review.

## Files in this folder

| File | Purpose |
|---|---|
| `BIOMNI_SYSTEM_PROMPT.md` | Standing instruction to paste into Biomni before each run |
| `BIOMNI_TASK.md` | Current task assigned to Biomni |
| `BIOMNI_OUTPUT_SUMMARY.md` | Biomni's post-run report |
| `OPEN_QUESTIONS_FOR_CHATGPT.md` | Uncertainties that need review |
| `NEXT_ACTION_RECOMMENDATION.md` | Biomni's recommendation, not final decision |
| `CHATGPT_REVIEW.md` | ChatGPT's review verdict |
| `DECISION_LOG.md` | Human-readable record of project decisions |

## Required Biomni behavior

For every task, Biomni must:

1. Read the relevant project files first.
2. Stay inside the authorized phase.
3. Create or update the supervision files.
4. Clearly list any uncertainty.
5. Mark unsupported information as `not verified`.
6. Stop after the requested task.
7. Wait for user / ChatGPT verification.

## Strict project boundaries

Unless explicitly authorized:

- No mutant model generation
- No docking
- No molecular dynamics
- No virtual screening
- No binding-affinity claims
- No invented ligand identifiers
- No invented SMILES
- No invented PDB IDs
- No unsupported aliases such as `GSK959`
