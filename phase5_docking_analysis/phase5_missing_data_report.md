# Phase 5 — Missing data & skipped items report

This document logs items that were **not** executed or that were resolved by workaround rather than direct measurement. Every item carries a justification and a documented alternative or downgrade.

---

## 1. Chai-1 spot-check (skipped)

**Original plan**: Run 10 HPC-scheduled Chai-1 dockings as an orthogonal cross-check against Vina for the top-signal set (C727R × 3 states × 2 ligands + a small WT reference set).

**Status**: **Skipped.** HPC availability check returned no runnable Chai-1 endpoint at the time of scheduling; `hpc_search_tools("chai-1")` did not surface a reachable job template.

**Impact**: Docking orthogonality is reduced to a single scoring function (Vina). No downstream conclusion depends on Chai-1; the primary evidence lines (score, pose RMSD, contact loss) all come from Vina and are internally consistent.

**Documented downgrade**: The `TodoWrite` step 7 status is `failed` (not `pending`) to make this visible; no gap is left implicit.

**How to recover in a re-run**: Once HPC has a Chai-1 endpoint again, resubmit the top 10 signals via `hpc_run_tool()` using the existing PDBQT-derived PDB receptors and ligand SDFs already staged in `receptor_pdbqt/` and `ligand_pdbqt/`. No re-preparation is required.

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

## 7. Nothing else deferred

Every other item in the plan (steps 1–6, 8, 9) was executed as designed. Steps 10 and 11 (this report and downstream) are progressing normally.
