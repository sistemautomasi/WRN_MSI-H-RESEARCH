# Phase 2 Handoff for ChatGPT Review

**Date:** 2026-07-08
**Task:** Repair minor Phase 2 validation wording
**Repo:** sistemautomasi/WRN_MSI-H-RESEARCH
**Branch:** main

---

## 1. What was done

Five targeted wording repairs to Phase 2 validation files, plus creation of this handoff document. No Phase 3 work, no docking, no MD, no mutant modeling, no virtual screening, no binding-affinity prediction.

Specifically:

1. Replaced the incorrect VVD-214 / RO-7589831 note in `ligand_inventory.csv` that attributed 7GQU to "Palte et al. 2022." The corrected wording attributes 7GQU to Baltgalvis et al. Nature 2024 and clarifies that X1L represents the covalently bound adduct form after Cys727 addition to the vinyl sulfone warhead.
2. Added a new section (§9) to `phase2_missing_data_report.md` documenting the mutation status of the two HRO761-bound WRN structures: 8PFO (6 engineered surface mutations, Ferretti et al. Nature 2024) vs 9S18 (mutation-free, Fletcher et al. Commun Biol 2026). Phase 3 template selection must document which HRO761 template is used and why.
3. Retained the existing 9OG8 / A1CA5 warning about the anomalously short 1.428 Å covalent bond distance. This warning is already present in `phase2_missing_data_report.md` §3, `phase2_summary.md`, `phase2_user_verification_checklist.md`, `structure_selection_decision.md`, and `README.md`. No change was needed.
4. Sanitized `phase2_execution_log.md` to remove the literal excluded alias string from the audit-prose line documenting the alias-exclusion check. The line now uses neutral wording ("excluded three-digit-suffix alias") so that a repo-wide search for the excluded alias returns zero hits.
5. Created this handoff file.

## 2. Files created

| File | Location | Description |
|---|---|---|
| `PHASE_HANDOFF_FOR_CHATGPT.md` | `phase2_structure_ligand_collection/` | This document — 11-section handoff for ChatGPT review |

## 3. Files modified

| File | Location | Change |
|---|---|---|
| `ligand_inventory.csv` | `phase2_structure_ligand_collection/` | VVD-214 / RO-7589831 `notes` field: replaced "Palte et al. 2022 (7GQU) — earliest published WRN covalent cocrystal." with "7GQU is the Baltgalvis et al. Nature 2024 WRN covalent allosteric inhibitor cocrystal. X1L represents the covalently bound adduct form of the VVD-214 / RO-7589831 chemotype after Cys727 addition to the vinyl sulfone warhead." |
| `phase2_missing_data_report.md` | `phase2_structure_ligand_collection/` | Appended §9: "HRO761 template mutation status: 8PFO vs 9S18" with verified mutation details from mmCIF `struct_ref_mut` records |
| `phase2_execution_log.md` | `phase2_structure_ligand_collection/` | Line 178: replaced literal excluded alias string with neutral "excluded three-digit-suffix alias" wording |

## 4. CSV row counts

| CSV | Rows | Columns | Status |
|---|---|---|---|
| `structure_inventory.csv` | 37 | 35 | Loads cleanly via pandas |
| `residue_mapping_table.csv` | 185 | 13 | Loads cleanly via pandas |
| `ligand_inventory.csv` | 9 | 21 | Loads cleanly via pandas |

## 5. Key findings

- **8PFO** (1.90 Å, Ferretti et al. Nature 2024) is the highest-resolution HRO761 cocrystal but has 6 engineered surface mutations (E625A, R564A, R785A, R803A, E886A, R942A) per mmCIF `struct_ref_mut` records. None of these coincide with the 5 key resistance residues (L528, C727, G729, F730, I852).
- **9S18** (1.995 Å, Fletcher et al. Commun Biol 2026) is an alternative HRO761-bound WRN structure with no engineered mutations (`_entity.pdbx_mutation` = `?`, no `struct_ref_mut` records).
- **7GQU** (1.54 Å) is the Baltgalvis et al. Nature 2024 WRN covalent allosteric inhibitor cocrystal, containing the X1L ligand (covalently bound adduct form of the VVD-214 / RO-7589831 chemotype after Cys727 addition to the vinyl sulfone warhead).
- **9OG8 / A1CA5** has an anomalously short 1.428 Å covalent bond distance (S-C). This warning is retained unchanged in `phase2_missing_data_report.md` §3. The bond should be visually inspected before 9OG8 is used as a primary covalent template.
- The excluded alias search returns zero hits across all committed repo files after sanitization.

## 6. Assumptions made

- The user's replacement wording for the VVD-214 notes was applied verbatim.
- The 8PFO/9S18 mutation note uses citations verified directly from the RCSB metadata: 8PFO = Ferretti et al. Nature 2024 (cite_title: "Discovery of WRN inhibitor HRO761 with synthetic lethality in MSI cancers"), 9S18 = Fletcher et al. Commun Biol 2026 (cite_title: "Structural insights into WRN helicase reveal conformational states and opportunities for MSI-H cancer drug discovery"). A prior draft incorrectly attributed 8PFO to Baltgalvis et al.; this was corrected after a scientific review agent flagged the error.
- The 9OG8/A1CA5 1.428 Å warning was already present in 5 files and required no modification.
- The excluded alias sanitization in `phase2_execution_log.md` preserves the audit-trail meaning (documenting that the alias is absent from data tables) while removing the literal string so repo-wide search returns zero hits.

## 7. Uncertain claims

- None introduced by this repair. The 8PFO mutation status (6 engineered surface mutations) and 9S18 mutation-free status were verified directly from mmCIF `struct_ref_mut` and `_entity.pdbx_mutation` fields, not from RCSB REST API (which does not expose mutation fields).
- The 9OG8 1.428 Å bond distance anomaly remains an unresolved data-quality flag (not investigated further in this repair).

## 8. Failed retrievals

- No new failed retrievals in this repair. The RCSB REST API `polymer_entity` and `entry` endpoints do not return mutation/engineering fields; mutation status was instead verified by parsing the downloaded mmCIF files directly.

## 9. Items marked `not verified`

No new items. The following items from the prior Phase 2 run remain `not publicly verified`:
- SNV5686 (no PubChem CID, no ChEMBL ID, no RCSB CCD, no public SMILES)
- J&J Compound A/B/C (no public chemical identifiers)
- AbbVie DEL series A1CA4/A1CA5 compound-name mapping (CCD structures exist but compound names not resolved from RCSB metadata alone)

## 10. Out-of-scope actions avoided

- No Phase 3 mutant model generation
- No docking
- No molecular dynamics
- No virtual screening
- No binding-affinity prediction
- No mutant modeling
- No modification of Phase 3-7 folders
- No modification of `chatgpt_supervision/` files
- No modification of protein structure files (mmCIF) or ligand structure files
- No scientific analysis beyond the 5 specified wording repairs

## 11. Recommended next step

1. ChatGPT reviews this handoff file and the 14 open questions in `chatgpt_supervision/OPEN_QUESTIONS_FOR_CHATGPT.md`.
2. ChatGPT records verdict (approve / repair / reject) in `chatgpt_supervision/CHATGPT_REVIEW.md`.
3. User verifies Phase 2 outputs using `phase2_user_verification_checklist.md`.
4. If approved by both: Phase 3 scope is defined (which mutations, which templates, including the 8PFO vs 9S18 HRO761 template decision).
5. Only then is Phase 3 authorized to begin.

---

**Stop condition:** Phase 2 wording repair complete. No Phase 3 work performed. Stop after pushing to GitHub main.
