# Decision Log

## 2026-07-08 — Supervision workflow created

Decision: Use GitHub as the shared workspace between Biomni, ChatGPT, and the user.

Rationale:

- Biomni is useful as an execution agent.
- ChatGPT should verify scientific judgement and phase decisions.
- GitHub provides a persistent audit trail.

Workflow:

1. ChatGPT writes or reviews the task.
2. User gives the task to Biomni.
3. Biomni executes only the authorized task.
4. Biomni updates the supervision files.
5. ChatGPT reviews the repository outputs.
6. User decides whether to proceed.

Boundary:

No new phase should begin without explicit user authorization after review.
