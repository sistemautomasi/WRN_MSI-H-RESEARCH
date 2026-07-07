# ChatGPT Supervision Folder

This folder coordinates the review handoff between **Biomni** (execution agent) and **ChatGPT** (scientific reviewer and phase supervisor).

## Roles

| Role | Agent | Responsibility |
|---|---|---|
| Execution agent | Biomni | Runs phases, generates outputs, prepares handoff documents |
| Scientific reviewer | ChatGPT | Reviews outputs, approves/repairs/rejects phases, authorizes next phase |
| User | Derma Nexus | Final authorization, verifies before next phase begins |

## File ownership

| File | Written by | Purpose |
|---|---|---|
| `BIOMNI_TASK.md` | Biomni | Declares the current task scope, inputs, outputs, and stop condition |
| `BIOMNI_OUTPUT_SUMMARY.md` | Biomni | Summarizes what was produced in the completed phase |
| `OPEN_QUESTIONS_FOR_CHATGPT.md` | Biomni | Lists issues requiring ChatGPT review |
| `NEXT_ACTION_RECOMMENDATION.md` | Biomni | Biomni's recommendation on approval and next steps |
| `DECISION_LOG.md` | Biomni (entries) / ChatGPT (entries) | Chronological log of key decisions |
| `CHATGPT_REVIEW.md` | ChatGPT | ChatGPT's review verdict (approve / repair / reject) and notes |
| `BIOMNI_RUN_INSTRUCTIONS.md` | User / ChatGPT | Instructions Biomni follows at session start |

## Current phase

**Phase 2 — Structure & Ligand Collection:** Completed by Biomni. Handoff prepared for ChatGPT review.

Phase 3 has NOT started and will NOT start until both ChatGPT and the user verify Phase 2 and explicitly authorize Phase 3.
