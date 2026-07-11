# Phase 4 Cross-Validation — Computational Signals vs Wet-Lab Literature

**Scope**: 3 druggable conformational states (9MJT/apo, 9S18/HRO761-bound, 7GQU/VVD-214-covalent).
9S19/DNA-bound has no coherent drug pocket (nearest-to-C727 pocket volume = 303 Å³, druggability = 0)
and is excluded from signal-counting. This is itself a finding — WRN in on-DNA catalytic state does not
present a druggable pocket at C727 site.

| Mutation | Our verdict | Templates | Clashes | Max vol Δ | Literature | Concordance |
|----------|-------------|-----------|---------|-----------|------------|-------------|
| L528S | no signal (0/3) | - | 0 | 0.7% | moderate | partial - both weak/moderate |
| C727A | weak (1/3 druggable states) | 7GQU | 0 | 67.9% | strong (covalent bond ablation) | literature stronger (pipeline detects only steric component) |
| C727S | no signal (0/3) | - | 0 | 5.3% | strong (covalent bond ablation) | DISCORDANT - literature strong, our pipeline blind (documented limitation) |
| C727R | strong (3/3 druggable states) | 7GQU,9MJT,9S18 | 13 | 72.2% | inferred strong (steric blockade) | concordant |
| G729D | strong (3/3 druggable states) | 7GQU,9MJT,9S18 | 22 | 1.9% | strong (allosteric H-bond flip) | concordant |
| F730L | no signal (0/3) | - | 0 | 3.0% | moderate (evolved resistance) | partial - both weak/moderate |
| I852F | strong (3/3 druggable states) | 7GQU,9MJT,9S18 | 6 | 3.2% | weak-moderate (indirect) | our signal higher (potential false positive from rotamer rebuild) |

## Key findings
- **C727R**: 3/3 states + 13 clashes (7GQU, mostly with F917). Strongest geometric signal.
- **G729D**: 3/3 states + 22 clashes total (with F730 and 728 backbone). Fowler 2026's D729-F730 mechanism reproducible from static PDBFixer models.
- **I852F**: 3/3 states + 6 clashes (consistently with pos 737). Weak in literature but robust in static geometry.
- **C727A/S**: pipeline blind to covalent chemistry (ligand removed for these mutants → -68% volume in 7GQU only from ligand removal effect, not sidechain).
- **F730L/L528S**: no static geometric signal; consistent with reported mechanism (π-stack loss, distal contact — beyond PDBFixer scope).