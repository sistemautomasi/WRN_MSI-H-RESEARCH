# WRN Phase 2 — User Verification Checklist

**Purpose:** 13-item checklist for the user to verify Phase 2 outputs before instructing Phase 3.

**Instructions:** For each item, tick the box after reviewing the referenced file(s) and confirming the underlying data.

---

## Structural inventory

**1. Structure count and scope**
- [ ] Verify that `structure_inventory.csv` contains **37 rows** representing 37 unique PDB IDs.
- [ ] Confirm that the 10 classic exonuclease-domain entries (2AXL, 2DGZ, 2E1E, 2E1F, 2FBT, 2FBV, 2FBX, 2FBY, 2FC0, 3AAF) and the 4 additional excluded entries (7XUT, 6TYV, 8YLE, 9HZG) are documented in `structure_selection_decision.md` §2 (Stage A, B, C) with clear reasons.
- [ ] Confirm that 10AJ, 10AK, and 10AP are correctly included as helicase-domain structures (per your prior instruction).

**2. Structure files present**
- [ ] Confirm that `protein_structure_files/` contains **37 mmCIF files** (one per in-scope PDB ID), all downloaded from RCSB unmodified.
- [ ] Spot-check any 2-3 files (e.g. 9S1B.cif, 10AK.cif, 6YHR.cif) open in your preferred molecular viewer and show the expected WRN helicase domain.

**3. Column completeness**
- [ ] Verify that `structure_inventory.csv` includes at minimum the columns: pdb_id, method, resolution_A, deposit_date, structure_state, drug_like_ligand_ccds, covalent_link_at_cys, covalent_distance_A, chain_ids, wrn_residue_range, cite_title, cite_year, phase1_inhibitor_mapping.
- [ ] Note: the actual CSV has 35 columns (a superset of the required 27 in the original plan). The extras carry coordinate-parsed and Phase 1 mapping information. Confirm this expansion is acceptable.

## Residue mapping

**4. Residue coverage**
- [ ] Verify `residue_mapping_table.csv` contains **185 rows** (37 structures × 5 resistance residues L528, C727, G729, F730, I852).
- [ ] Confirm that 179/185 = 96.8% of mappings are marked `yes` (residue present and correct identity).
- [ ] Confirm that the 6 `no` entries all fall in the L528 row for 9MJS, 9RTI, 9RUR, 9RUS, 9S17, 9S1A (i.e., L528 absent because the polymer construct starts after residue 528).

**5. Numbering scheme**
- [ ] Verify that `auth_seq_id` in every structure matches UniProt Q14191 canonical numbering. (No renumbering / offset issues detected across 37 in-scope structures.)

## Ligand inventory

**6. Verified inhibitors**
- [ ] Verify `ligand_inventory.csv` contains rows for the 6 Phase 1 inhibitors plus 3 additional cocrystal ligands (YH8, GSK5819992, GSK4766470).
- [ ] Confirm HRO761 is verified with PubChem CID **166140536**, InChIKey `XKYVECRUZPCRQR-UHFFFAOYSA-N`, and mapped to RCSB CCD `YHC` in PDB entries **8PFO** and **9S18**.
- [ ] Confirm VVD-214 / RO7589831 is verified with PubChem CID **170717998** and mapped to RCSB CCD `X1L` in **7GQU** as its covalent-adduct form (reduced vinyl sulfone).
- [ ] Confirm GSK4418959 / IDE275 is verified with PubChem CID **172618374** (primary) + 172618744 (enantiomer), with **no** public cocrystal in RCSB.

**7. Not-publicly-verified inhibitors**
- [ ] Confirm that SNV5686, J&J Compound A/B/C, and AbbVie DEL series are documented as `not publicly verified` in `phase2_missing_data_report.md` §1, and that their sponsor/company attribution has NOT been fabricated where absent from the source (SNV5686 abstract does not specify company; do not invent one).

## Covalent chemistry

**8. Cys727 covalent cocrystals**
- [ ] Verify that `structure_inventory.csv` flags exactly **10 structures** with `covalent_link_at_cys` entries corresponding to Cys727 (for example `Cys727(A)` or `Cys727(A);Cys727(B)`): 10AK, 10AP, 7GQU, 9OG8, 9QBU, 9QBV, 9RTI, 9RUR, 9S17, 9S1B.
- [ ] Confirm no covalent bonds at other cysteines (C519, C623, C724, C1041) were identified.

**9. 9OG8 bond distance anomaly**
- [ ] Review `phase2_missing_data_report.md` §3 for the flag on 9OG8's unusually short (1.428 Å) covalent bond distance and decide whether the entry should be de-prioritized as a Phase 3 template.

## Conformational state classification

**10. State distribution**
- [ ] Verify the 37 structures classify as: 10 covalent-ligand-bound, 10 non-covalent inhibitor-bound, 9 fragment-bound, 5 nucleotide-bound, 1 DNA-bound (9S19), 2 apo (9MJT, 9S1A).
- [ ] Spot-check 2-3 classifications against RCSB titles or the paper they cite.

## Reproducibility

**11. Execution log**
- [ ] Review `phase2_execution_log.md` and confirm every REST endpoint used, every filter rule applied, and every anomaly encountered is documented.

**12. Original data preserved**
- [ ] Confirm no coordinates have been altered (per `phase2_missing_data_report.md` §8).
- [ ] Confirm whether the raw JSON intermediates from the original execution workspace `/workspace/wrn_phase2_structures/` (for example `rcsb_metadata_raw.json`, `link_records_all.json`, `residue_maps.json`, `ccd_ligand_metadata.json`) were separately preserved for audit. If they are not present in the repository handoff, treat the CSVs and downloaded structure files as the primary delivered artifacts.

## Decision point

**13. Proceed to Phase 3?**
- [ ] Confirm whether Phase 3 (mutant model generation) is authorized, and if so:
    - [ ] Which primary WT template(s) to use? Default suggestion: 9MJT (apo, 1.73 Å) + 6YHR (ADP-bound, 2.2 Å).
    - [ ] Which covalent-bound template(s) for C727 mutants? Default suggestion: 9S1B (2.22 Å, GSK_WRN3) or 10AK (1.37 Å, cyclic vinyl sulfone).
    - [ ] Which non-covalent template(s) for HRO761 modeling? Default suggestion: 8PFO (1.9 Å, YHC = HRO761 exactly).
    - [ ] Which DNA-bound template? Default suggestion: 9S19.
    - [ ] Which of the 7 mutations (L528S, C727A, C727S, C727R, G729D, F730L, I852F) should be modeled and against which templates?
    - [ ] Confirm MD remains ON HOLD.

---

**Once all 13 items have been reviewed and any issues resolved, please provide explicit approval to proceed to Phase 3.**