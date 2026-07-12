# Chai-1 Orthogonal Validation — Phase 5 Addendum

**Status**: Attempted / INCONCLUSIVE (documented negative result).
**Date**: 2026-07-12
**Purpose**: Cross-check the Vina docking-based mutation ranking with an orthogonal ML co-fold method (Chai-1) to test whether the C727R displacement pattern is method-specific or reproducible.
**Verdict**: Chai-1 (no-MSA mode) does **not** provide orthogonal validation of the Vina C727R displacement finding. Within-run sampling variance (~23 Å pairwise centroid spread across 5 diffusion samples) **exceeds** between-mutation apparent signal (~16 Å range of mean distances). Results should not be used as independent evidence.

---

## 1. Scope

10 systems selected from the Vina top-ranked panel:

| # | docking_id | Template | Ligand | Mutation category |
|---|---|---|---|---|
| 1 | WT_9MJT_VVD-214 | 9MJT | VVD-214 | WT baseline |
| 2 | WT_9S18_HRO761 | 9S18 | HRO761 | WT baseline |
| 3 | C727R_9MJT_VVD-214 | 9MJT | VVD-214 | Cys727 mutant |
| 4 | C727R_9S18_HRO761 | 9S18 | HRO761 | Cys727 mutant (top Vina hit) |
| 5 | C727S_9MJT_VVD-214 | 9MJT | VVD-214 | Cys727 mutant |
| 6 | C727S_9MJT_VVD-214_cov | 9MJT | VVD-214 | Same as #5, second run (identical FASTA) |
| 7 | C727A_9MJT_VVD-214_cov | 9MJT | VVD-214 | Cys727 mutant |
| 8 | G729D_9MJT_VVD-214 | 9MJT | VVD-214 | Adjacent (Fowler 2026 allosteric residue) |
| 9 | F730L_9MJT_VVD-214 | 9MJT | VVD-214 | Adjacent |
| 10 | L528S_9MJT_VVD-214 | 9MJT | VVD-214 | Distal (Ferretti 2024 resistance) |

Chai-1 does not implement explicit covalent chemistry — the `_cov` suffix on rows 6/7 refers to the corresponding Vina covalent-mode run; the Chai-1 FASTA is identical to the non-cov counterpart. Verified by md5 hash comparison: `C727S_9MJT_VVD-214.fasta` == `C727S_9MJT_VVD-214_cov.fasta` (both `0a546e9cc9e872616a30c04048073ccd`).

**Ligands** (SMILES verified against PubChem):
- HRO761 (CID 166140536): `CCC1=C(C(=O)N2C(=NC(=N2)C3=CCOCC3)N1CC(=O)NC4=C(C=C(C=C4)C(F)(F)F)Cl)N5CCN(CC5)C(=O)C6=NC=NC(=C6O)C` — C31H31ClF3N9O5, MW 702.1, 49 heavy atoms.
- VVD-214 (CID 170717998): `CC(C1=NC=C(C(=N1)OC2=CC=CC=C2)C(=O)N[C@H](/C=C/S(=O)(=O)C)C3CC3)(F)F` — C20H21F2N3O4S, MW 437.5, 30 heavy atoms.

## 2. Method

- **Chai-1** (`chai-lab fold`) on Phylo HPC, GPU-backed, 3 concurrent jobs max.
- Protein sequence: 443-aa helicase domain extracted directly from Phase 5 Vina input PDBQTs at `receptor_pdbqt/{9MJT,9S18}_WT_prepared.pdbqt`. Local resid 228 (9MJT) / 227 (9S18) = canonical Cys727.
- Mutation application: `canonical_pos − offset` mapping (offsets: 9MJT=499, 9S18=500). Applied and verified in-place before submission.
- Runtime: 4–8 min per job.
- **Intended mode**: `--use-msa-server` (queries ColabFold API for multiple sequence alignment) for maximum accuracy.
- **Actual mode**: no-MSA (single-sequence input) — see §3.
- Each job returns 5 diffusion samples (`pred.model_idx_{0..4}.cif`) + 5 confidence score archives (`.npz`).

## 3. Error condition — ColabFold MSA server unreachable

4/4 `--use-msa-server` submissions failed with:

```
ConnectionError: HTTPSConnectionPool(host='api.colabfold.com', port=443): Read timed out.
```

Failed job IDs:
- `688f6f4a-29e5-4b5c-bf0f-a3184412042e` C727R_9S18_HRO761 (with-MSA, initial)
- `6a5a8721-c827-49c2-b4fb-33043dfaa1dd` C727R_9MJT_VVD-214 (with-MSA)
- `f144aa8f-de96-405a-bbce-107ae37e1d2c` C727S_9MJT_VVD-214 (with-MSA)
- `4740a8c8-e937-460a-a43a-c136cbbf568d` C727R_9S18_HRO761 (with-MSA retry)

After 4 consecutive failures across the retry window, `--use-msa-server` was dropped for panel consistency. All 10 systems were re-submitted in no-MSA mode. This is **not** a Chai-1 or HPC failure — it is an external dependency on the free ColabFold API which was degraded during the run window.

## 4. Results — 10/10 completed jobs

### Confidence metrics (model_idx_0, representative — all 5 models within ±0.005 of these values)

| docking_id | pTM | ipTM | prot_pTM | lig_pTM | inter-chain clashes |
|---|---|---|---|---|---|
| WT_9MJT_VVD-214 | 0.743 | 0.169 | 0.756 | 0.653 | 0 |
| WT_9S18_HRO761 | 0.721 | 0.178 | 0.755 | 0.672 | 0 |
| C727R_9MJT_VVD-214 | 0.757 | 0.177 | 0.777 | 0.652 | 0 |
| C727R_9S18_HRO761 | 0.740 | 0.191 | 0.777 | 0.679 | 0 |
| C727S_9MJT_VVD-214 | 0.744 | 0.176 | 0.710 | 0.656 | 0 |
| C727S_9MJT_VVD-214_cov | 0.741 | 0.166 | 0.767 | 0.663 | 0 |
| C727A_9MJT_VVD-214_cov | 0.746 | 0.174 | 0.771 | 0.659 | 0 |
| G729D_9MJT_VVD-214 | 0.758 | 0.179 | 0.783 | 0.665 | 0 |
| F730L_9MJT_VVD-214 | 0.768 | 0.171 | 0.800 | 0.652 | 0 |
| L528S_9MJT_VVD-214 | 0.744 | 0.165 | 0.762 | 0.654 | 0 |

**Interpretation of confidence metrics**:
- pTM 0.72–0.77 across all 10 systems — protein-alone folding is reasonable.
- **ipTM 0.17–0.19 for every system** — Chai-1's interface confidence is uniformly LOW (typical high-quality co-fold gives ipTM ≥ 0.5–0.7). No system reached the interface threshold Chai-1 authors recommend for confident co-fold interpretation.
- No inter-chain clashes across 50 predictions (5 models × 10 systems).
- Uniformly low ipTM across all systems means **the model itself is signaling low confidence in the ligand-binding pose everywhere**.

### Ligand-to-canonical-C727 distance (Å, first-model)

| docking_id | lig→C727 (mean of 5 models) | Range across models | Would be "in Vina pocket"? |
|---|---|---|---|
| WT_9MJT_VVD-214 | 19.4 | 16.1 – 28.4 | No |
| WT_9S18_HRO761 | 33.2 | 32.7 – 33.7 | No |
| C727R_9MJT_VVD-214 | 19.7 | 16.2 – 31.0 | No |
| C727R_9S18_HRO761 | 33.2 | 32.6 – 34.2 | No |
| C727S_9MJT_VVD-214 | 19.0 | 16.1 – 27.4 | No |
| C727S_9MJT_VVD-214_cov | 20.4 | 16.1 – 34.5 | No |
| C727A_9MJT_VVD-214_cov | 16.8 | 15.9 – 17.9 | No |
| G729D_9MJT_VVD-214 | 22.9 | 16.1 – 33.4 | No |
| F730L_9MJT_VVD-214 | 23.9 | 16.5 – 34.2 | No |
| L528S_9MJT_VVD-214 | 25.4 | 16.3 – 33.9 | No |

Contact distance (heavy atom → C727 CA) for a bound ligand is typically 5–8 Å. Not a single Chai-1 model of any of the 10 systems placed the ligand within 15 Å of the canonical C727 pocket.

**Chai-1 (no-MSA) does not reproduce the canonical WRN helicase C727 pocket for WT baselines, so it cannot serve as an orthogonal check for mutation effects at that pocket.**

## 5. Signal-to-noise assessment (why the initial "Group A vs B" clustering does not hold)

Preliminary analysis on the first-model distance saw a putative 2-group split:
- Group A (`~16–18 Å`): C727 mutations on 9MJT + G729D
- Group B (`~28–34 Å`): WT + 9S18 systems + L528S + F730L

However:

1. **Identical-FASTA control fails**. `C727S_9MJT_VVD-214` (first-model 16.1 Å) and `C727S_9MJT_VVD-214_cov` (first-model 34.5 Å) used *bit-identical* FASTAs but produced first-model ligand poses 18 Å apart. Since the input was identical, the observed 16 → 34 Å swing is **pure stochastic sampling variance** in Chai-1's diffusion process, not a mutation effect.

2. **Within-run variance dominates between-mutation range**.

| Statistic | Value |
|---|---|
| Between-mutation range (mean lig→C727 across 10 systems) | 16.4 Å (16.8 → 33.2) |
| Within-run centroid pairwise mean (5 samples/job) | 23.3 Å |
| Within-run centroid pairwise SD | ~7 Å |
| Signal-to-noise ratio (between-mutation / within-run) | **0.70** |

Signal-to-noise < 1 means: the mean position across mutations differs by less than the scatter of positions within a single job. The apparent between-mutation clustering cannot be distinguished from single-job sampling noise.

3. **The one apparently reproducible feature — that 9S18 systems place the ligand consistently ~33 Å from C727 while 9MJT systems scatter more — is likely a template-structure effect (initial protein conformation), not a mutation effect.**

## 6. What this run CAN and CANNOT support

**Can support**:
- Protein-alone folding is reasonable (pTM 0.72–0.77) for the extracted 443-aa helicase domain.
- No clashes appeared across 50 predictions.
- The Chai-1 job pipeline (HPC submission, output retrieval, CIF parsing) is validated end-to-end.
- Chai-1's own confidence metric (ipTM) flags every one of these predictions as low-confidence — the tool is honest about its uncertainty.

**Cannot support**:
- Orthogonal validation of the Vina C727R displacement finding.
- Any claim about differential ligand binding across mutations from Chai-1 alone.
- The initial "Group A vs B" clustering hypothesis (falsified by identical-FASTA control).

## 7. What would be needed to make this valid

The right way to run Chai-1 for this validation:
1. Restore `--use-msa-server` mode when the ColabFold API stabilises (or supply a cached MSA).
2. Run **≥5 independent seeds per system** (n=50 poses per system, not 5) to average over diffusion sampling variance.
3. Provide the crystallographic protein–ligand complex as a template (Chai-1 template mode) so the model has a starting point in the C727 pocket.
4. Report per-system pose distributions (histograms of lig→C727 distance) rather than single-model scalars.

None of the above changes the Vina Phase 5 conclusions — this addendum is scoped to whether Chai-1 as run here provides orthogonal support (it does not).

## 8. Files in this folder

- `README.md` — this file.
- `job_manifest.csv` — 14 rows: 10 successful no-MSA jobs + 4 with-MSA failure records.
- `chai1_pose_analysis.csv` — 10 rows: per-system first-model confidence metrics + ligand-to-residue distances for C727, G729, F730, L528, I852.
- `chai1_within_run_variance.csv` — 10 rows: within-run centroid pairwise stats + lig→C727 min/max/mean/SD across 5 diffusion samples per system.
- `fig8_chai1_orthogonal.png` / `.svg` — 4-panel diagnostic figure: confidence metrics, distance-to-C727 bars with ranges, within-run variance bars, signal-to-noise summary.

Chai-1 raw outputs (5 CIF + 5 npz per job) at `/mnt/results/hpc_<job_id>/outputs/`. Job IDs are listed in `job_manifest.csv`.

## 9. Reproducibility

- Chai-1 tool ID and command: retrieved via `hpc_search_tools("chai fold")`. Command form: `chai-lab fold /input/{docking_id}.fasta /output` (no additional flags used in successful runs).
- Input FASTAs at `/workspace/chai1_fastas/{docking_id}.fasta`. Each file is a 2-record FASTA: `>protein|name=WRN_{mut}_{tmpl}` + 443-aa sequence, then `>ligand|name={ligand}` + SMILES.
- Analysis code: within the corresponding worker notebook cells; ligand extraction uses column indices verified against a raw HETATM line (indices 2/element, 3/atom_id, 5/resname, 9/chain, 10-12/xyz).
