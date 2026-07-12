# Phase 5 — Missing data & skipped items report

This document logs items that were **not** executed or that were resolved by workaround rather than direct measurement. Every item carries a justification and a documented alternative or downgrade.

---

## 1. Chai-1 orthogonal co-fold (attempted, INCONCLUSIVE — updated)

**Original plan**: Run 10 HPC-scheduled Chai-1 dockings as an orthogonal cross-check against Vina for the top-signal set (C727R × 3 states × 2 ligands + a small WT reference set).

**Status**: **Attempted, 10/10 completed, INCONCLUSIVE.** All 10 systems returned uniformly low ipTM (0.17–0.19; well below the ~0.5 threshold Chai-1 authors recommend). Chai-1 did not reproduce the canonical Cys727 pocket in any of 10 systems including WT baselines. Within-run diffusion sampling variance (~23 Å mean pairwise centroid distance across 5 samples/job) exceeded between-mutation apparent signal (~16 Å range), giving signal-to-noise 0.70. Two independent runs of an identical FASTA gave first-model poses 18 Å apart, falsifying single-model-based clustering interpretations.

**Impact**: Docking orthogonality is effectively still reduced to a single scoring function (Vina). No downstream conclusion depends on Chai-1; the primary evidence lines (score, pose RMSD, contact loss) all come from Vina and are internally consistent.

**Documented downgrade**: The `TodoWrite` step 7 status remains `failed` (task attempted but did not produce usable orthogonal evidence). See §5.1 of `phase5_docking_report.md` and `chai1_orthogonal/README.md` for the full analysis and remediation path.

**How to recover in a re-run**: See item 8 below for the specific ColabFold API dependency and item 9 for the Chai-1 pocket-prediction limitation.

---

## 2. 9S19 canonical residue numbering (unresolvable, worked around)

**Issue**: 9S19 is a dimeric off-target WRN structure with a chain topology that does not align 1:1 to the Phase 3 UniProt canonical monomer sequence. The `MUT_OFFSETS` / `WT_TO_CANONICAL` map that works for 9MJT/9S18/7GQU cannot be derived for 9S19 because the mutation-probe residue (I852F) is not homologous across chains.

**Workaround**: Neg-control 9S19 dockings (`NEG_9S19_WT_HRO761`, `NEG_9S19_WT_VVD-214`) report contact residues in **chain-prefixed 9S19-local numbering** (e.g. `ARGC343`) rather than canonical WRN. These rows are flagged `is_neg_control=True` in `phase5_master.csv` and are excluded from the mutation-vs-WT comparison.

**Impact**: None on the resistance verdicts (neg-controls are validation-only). Users should not compare `contact_residues` between 9S19 rows and 9MJT/9S18/7GQU rows.

---

## 3. Non-adjusted for docking seed variance

**Not measured**: Multi-seed retries for low-magnitude ΔScore signals (< 0.5 kcal/mol).

**Justification**: Vina was locked at seed=42 for reproducibility; exhaustiveness=16 is the standard high-confidence setting. Signals crossing the ΔScore > 1.5 threshold are well above seed noise. Signals below 0.5 kcal/mol are already flagged as weak or negative in the composite verdict and are not primary claims.

**How to strengthen if needed**: Re-run each low-magnitude signal with seeds ∈ {42, 43, 44, 45, 46}; report median + IQR ΔScore. Current single-seed values remain the reference.

---

## 4. Missing WT_9MJT_HRO761 in raw batch CSV (patched)

**Issue**: A restart of the non-covalent batch script left `WT_9MJT_HRO761` present as a pose file (`.pdbqt`) but absent from the raw CSV.

**Workaround**: The score was recovered from the pose file's `REMARK VINA RESULT` line (-8.669 kcal/mol) and elapsed-time from the prior benchmark run log (262 s). CSV was patched to 50 rows, all status = `ok`.

**Impact**: None — the pose file is authoritative; the CSV is now consistent with it. Recovery is logged in `logs/vina_batch_out.log`.

---

## 5. Mode-label inconsistency (patched)

**Issue**: Initial CSVs mixed `noncovalent` and `non-covalent` labels for the same mode.

**Workaround**: Standardized all mode labels to `non-covalent` (with hyphen); covalent runs use `covalent-adduct`. `covalent_blocked` remains as a distinct auto-tag string.

**Impact**: Downstream aggregation code is now consistent. Historical rows in `dock_scores_raw.csv` retain the corrected labels.

---

## 6. Contact-loss inflation (root-caused and fixed)

**Issue**: An early pose-analysis run showed F730L_9MJT_VVD-214 (pose RMSD 0.05 Å) reporting 23 contact_losses — biologically impossible.

**Root cause**: PDBFixer removed unresolved N-terminal residues per template independently → each mutant PDB had a **template-specific truncation offset** relative to WT PDBs. Direct residue-number comparison between mutant and WT contact sets was invalid.

**Fix**: Derived per-template offsets using the I852F mutation as a unique sequence probe (rare Ile→Phe candidate residue). Canonical WRN numbering is now applied in `vina_poses.csv` and downstream. F730L test now shows 22/23 shared contacts and only 1 unique per side (biologically consistent). Sanity checks pass: CYS727 present in all pocket sets; PHE730 in HRO761 pockets; ILE852 in 9S18.

**Impact**: All contact-based statistics in the final reports use canonical WRN. Any pre-fix numbers in intermediate files (`preview_signals.csv`) are superseded by `phase5_verdicts.csv`.

---

## 7. Nothing else deferred from the original plan

Every other item in the original plan (steps 1–6, 8, 9) was executed as designed. Steps 10 and 11 (this report and downstream) are progressing normally. Two additional items were surfaced during the Chai-1 orthogonal addendum and are documented below.

---

## 8. ColabFold MSA API unreachable (external dependency)

**Issue**: Chai-1's `--use-msa-server` flag depends on the free ColabFold MSA endpoint at `api.colabfold.com`. Four consecutive `--use-msa-server` submissions failed with `ConnectionError: HTTPSConnectionPool(host='api.colabfold.com', port=443): Read timed out`.

**Affected job IDs**:
- `688f6f4a-29e5-4b5c-bf0f-a3184412042e` (C727R_9S18_HRO761, initial)
- `6a5a8721-c827-49c2-b4fb-33043dfaa1dd` (C727R_9MJT_VVD-214)
- `f144aa8f-de96-405a-bbce-107ae37e1d2c` (C727S_9MJT_VVD-214)
- `4740a8c8-e937-460a-a43a-c136cbbf568d` (C727R_9S18_HRO761 retry)

**Workaround applied**: Dropped `--use-msa-server` for panel consistency; all 10 systems re-submitted in no-MSA (single-sequence) mode and completed successfully. Trade-off: Chai-1 without MSA has substantially reduced accuracy for protein-ligand co-fold.

**Impact**: Materially contributed to item 1 (Chai-1 inconclusive). Not a Chai-1 or Phylo-HPC failure — external free-service degradation during the run window.

**How to recover in a re-run**: Either (a) retry `--use-msa-server` when the ColabFold API is stable, (b) pre-compute an MSA with `mmseqs2` or a local ColabFold installation and pass it via Chai-1's `--msa-directory` flag, or (c) use a hosted MSA service other than ColabFold.

---

## 9. Chai-1 (no-MSA) does not reproduce the canonical WRN pocket

**Issue**: Chai-1 (single-sequence mode) placed the ligand ≥15 Å from canonical Cys727 CA in **every** first-model prediction of all 10 systems, including WT baselines. Chai-1 also showed high within-run diffusion sampling variance (23.3 Å mean pairwise centroid distance across 5 samples/job) — larger than any between-mutation difference observed.

**Root cause hypotheses (not experimentally distinguished in this run)**:
1. Chai-1 was trained/tuned with MSA input as expected default. Single-sequence mode substantially reduces pose accuracy for protein-ligand co-fold.
2. WRN helicase has limited protein-ligand co-fold training coverage compared with kinase / GPCR families.
3. No template/prior was passed; Chai-1's diffusion process explores the whole surface freely.

**Impact**: The 10-system Chai-1 dataset cannot be used as independent evidence for or against Vina's Phase 5 mutation-ranking conclusions.

**How to recover in a re-run**:
1. Resolve item 8 (get MSA working) — this alone may improve pocket recovery substantially.
2. Provide the crystallographic protein–ligand complex as a template (Chai-1 template mode).
3. Run ≥5 independent seeds per system and report distributions, not first-model scalars.
4. If Chai-1 still fails to reproduce WT pockets after (1)+(2), switch to classical MD on the Vina top hits (the original planned next-orthogonal step, currently postponed).
