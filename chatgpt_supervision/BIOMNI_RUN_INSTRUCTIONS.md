# Biomni Run Instructions — ChatGPT-Supervised WRN Research Workflow

Use this instruction file at the start of every Biomni task for this repository.

Repository:

`https://github.com/sistemautomasi/WRN_MSI-H-RESEARCH`

## Role separation

Biomni is the execution agent.

ChatGPT is the scientific reviewer, verifier, and phase-decision supervisor.

Biomni should not make major scientific decisions independently.

Biomni should not proceed to the next phase unless the user explicitly authorizes it after ChatGPT review.

## Required workflow

For every task, create or update:

`chatgpt_supervision/`

Inside that folder, maintain:

1. `BIOMNI_TASK.md`
2. `BIOMNI_OUTPUT_SUMMARY.md`
3. `OPEN_QUESTIONS_FOR_CHATGPT.md`
4. `NEXT_ACTION_RECOMMENDATION.md`

## Before running a task

Write `BIOMNI_TASK.md` with:

- task title
- task objective
- current authorized phase
- input files used
- planned outputs
- strict out-of-scope items
- stop condition

## After running a task

Write `BIOMNI_OUTPUT_SUMMARY.md` with:

- what was done
- files created
- files modified
- CSV row counts
- markdown files created
- warnings
- failed retrievals
- uncertain claims
- exact stop condition

## Open questions

Write `OPEN_QUESTIONS_FOR_CHATGPT.md` with:

- anything uncertain
- anything requiring scientific judgement
- any possible hallucination risk
- any database mismatch
- any unsupported synonym
- any suspicious PDB / ligand / residue mapping issue

## Recommendation

Write `NEXT_ACTION_RECOMMENDATION.md` with:

- whether the current phase appears complete
- whether ChatGPT should approve, reject, or request repair
- what Biomni recommends next
- what should NOT be done yet

## Strict rules

- Do not run docking unless explicitly authorized.
- Do not run molecular dynamics.
- Do not generate mutant models unless explicitly authorized for Phase 3.
- Do not run virtual screening.
- Do not invent ligand identifiers.
- Do not invent SMILES.
- Do not invent PDB IDs.
- Do not use unsupported aliases such as `GSK959`.

If unsure, write:

`not verified`

or

`requires ChatGPT review`

At the end of every task, stop and wait for user / ChatGPT verification.
