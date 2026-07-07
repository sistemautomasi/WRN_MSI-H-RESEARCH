# Open Questions for ChatGPT Review

The following 14 issues require ChatGPT review before Phase 3 can be authorized. Each question is grounded in a specific finding from the Phase 2 outputs.

## Template selection questions

### 1. Is 9MJT acceptable as the best apo WT reference?

**Context:** 9MJT is an X-ray structure at 1.73 Å resolution with all 5 resistance residues (L528, C727, G729, F730, I852) present. It is one of only 2 apo structures in the 37-structure inventory (the other is 9S1A at 1.956 Å, which is missing L528).

**Source:** `phase2_structure_ligand_collection/phase2_summary.md` §6; `structure_inventory.csv` row 9MJT.

### 2. Is 8PFO acceptable as the HRO761-bound template?

**Context:** 8PFO is an X-ray structure at 1.9 Å with ligand CCD YHC, which matches HRO761 by exact InChIKey (`XKYVECRUZPCRQR-UHFFFAOYSA-N`). HRO761 is also present in 9S18 (same CCD YHC).

**Source:** `phase2_structure_ligand_collection/phase2_summary.md` §6; `structure_inventory.csv` row 8PFO; `ligand_inventory.csv` row HRO761.

### 3. Is 7GQU acceptable as the VVD-214 covalent C727 template?

**Context:** 7GQU is an X-ray structure at 1.54 Å with ligand CCD X1L (the covalent adduct form of VVD-214, reduced vinyl sulfone) covalently bonded to Cys727-SG at 1.820 / 1.807 Å. This is the only public VVD-214 covalent cocrystal.

**Source:** `phase2_structure_ligand_collection/phase2_summary.md` §6; `structure_inventory.csv` row 7GQU; `ligand_inventory.csv` row VVD-214.

### 4. Should 10AK be considered the best high-resolution covalent C727 template?

**Context:** 10AK is an X-ray structure at 1.37 Å (highest resolution among all 37 structures) with ligand CCD A1C4L (cyclic vinyl sulfone series, 2026) covalently bonded to Cys727-SG at 1.775 / 1.790 Å. All 5 resistance residues are present.

**Source:** `phase2_structure_ligand_collection/phase2_summary.md` §6; `structure_inventory.csv` row 10AK.

### 5. Should 9S19 be used as the DNA-bound reference?

**Context:** 9S19 is an X-ray structure at 2.3 Å with `has_polynucleotide = True`. It is the only DNA-bound structure in the 37-structure inventory.

**Source:** `phase2_structure_ligand_collection/phase2_summary.md` §6; `structure_inventory.csv` row 9S19.

## Data-quality questions

### 6. Is the 9OG8 covalent bond distance issue serious enough to exclude it from Phase 3?

**Context:** 9OG8 reports a Cys727-SG to A1CA5 ligand covalent bond distance of 1.428 Å, which is anomalously short compared to standard S-C single bonds (~1.80 Å) and the range of other covalent Cys727 distances in this dataset (1.738–1.826 Å). The bond type is confirmed covalent (`_struct_conn` type `covale`), but the reported length is closer to a C=C or C=N distance. Possible explanations include refinement artifact, mis-assigned acceptor atom, or genuine strained geometry.

**Source:** `phase2_structure_ligand_collection/phase2_missing_data_report.md` §3; `structure_inventory.csv` row 9OG8.

## Inhibitor handling questions

### 7. How should GSK4418959 / IDE275 be handled since no public cocrystal exists?

**Context:** GSK4418959 / IDE275 is PubChem-verified (CID 172618374 + enantiomer 172618744, InChIKey `CPNRNECAIBPHJF-MVOZIGHISA-N`, MW 646.19) and an SDF is saved in `ligand_structure_files/`. However, no public cocrystal exists in RCSB. The 9QBU (A1I5L = GSK5819992) and 9QBV (A1I5F = GSK4766470) structures are different GSK compounds, not GSK4418959. Phase 3 docking or pose modeling for GSK4418959 would need to be de novo against a WRN template, not template-guided.

**Source:** `phase2_structure_ligand_collection/phase2_missing_data_report.md` §2a; `ligand_inventory.csv` row GSK4418959 / IDE275.

### 8. Should SNV5686 be excluded from structural modeling due to missing public chemistry?

**Context:** SNV5686 is disclosed in AACR 2025 abstract 2921 (Liu, Yang, Ferrante et al., DOI 10.1158/1538-7445.am2025-2921) as a differentiated WRN inhibitor with activity against both WT WRN and WRN-C727S mutant. However, no PubChem CID, no ChEMBL ID, no RCSB CCD, and no SMILES are publicly available. Sponsor company is not disclosed in the abstract. SNV5686 cannot be modeled from public data alone.

**Source:** `phase2_structure_ligand_collection/phase2_missing_data_report.md` §1a; `ligand_inventory.csv` row SNV5686.

### 9. Should J&J Compound A/B/C be excluded from structural modeling due to missing public identifiers?

**Context:** J&J Compound A/B/C (Janssen) is referenced in Phase 1 as a WRN inhibitor series associated with a Cys672-adjacent covalent site. No PubChem CID, no ChEMBL ID, and no RCSB CCD or PDB entry were found. Names are too generic for name-search. Cannot be modeled from public data.

**Source:** `phase2_structure_ligand_collection/phase2_missing_data_report.md` §1b; `ligand_inventory.csv` row JJ_Compound_A_B_C.

### 10. How should AbbVie DEL ligands A1CA4 / A1CA5 be treated without exact compound-name mapping?

**Context:** Ligand CCDs A1CA4 (in 9OG3) and A1CA5 (in 9OG8) exist in RCSB and SDFs are available. The RCSB paper attribution (Tong et al. 2025 J Med Chem, DOI 10.1021/acs.jmedchem.4c03029) suggests these are AbbVie DEL-derived compounds. However, their SMILES do not match GSK4418959 or any named Phase 1 inhibitor. The exact AbbVie compound names for A1CA4 and A1CA5 are not resolved from RCSB CCD metadata alone; the Tong et al. full text would be needed for compound-name → CCD mapping.

**Source:** `phase2_structure_ligand_collection/phase2_missing_data_report.md` §1c; `ligand_inventory.csv` row AbbVie_DEL_series.

## Phase 3 scope questions

### 11. Should Phase 3 model all 7 mutations or only a priority subset?

**Context:** The Phase 1 mutation panel is: L528S, C727A, C727S, C727R, G729D, F730L, I852F. Modeling all 7 on multiple templates would generate a large number of mutant models. A priority subset (e.g., the 3 C727 variants + L528S + F730L) might be more tractable. This is a scientific scope decision for ChatGPT.

**Source:** `README.md` Key Mutations table; `phase2_structure_ligand_collection/phase2_summary.md` §7.

### 12. Should Phase 3 use one primary template or multiple conformational-state templates?

**Context:** Phase 2 identified best templates per conformational state (apo 9MJT, HRO761-bound 8PFO, VVD-214 covalent 7GQU, DNA-bound 9S19, nucleotide-bound 9MJS/6YHR/8PFP). Using one primary template (e.g., 9MJT apo) would simplify modeling but lose state-specific pocket geometry. Using multiple templates would capture conformational-state effects but multiply the number of mutant models.

**Source:** `phase2_structure_ligand_collection/phase2_summary.md` §6 and §7.

## Boundary condition confirmations

### 13. Confirm again: no MD yet.

**Context:** Molecular dynamics remains on hold per project directive. No MD simulations, no MD system preparation, and no MD-related files (`.tpr`, `.gro`, `.top`, `.mdp`, `.dcd`, `.xtc`, `.trr`) were created in Phase 2. This is a re-confirmation that MD should remain on hold for Phase 3.

**Source:** Project directive; `chatgpt_supervision/BIOMNI_OUTPUT_SUMMARY.md` boundary conditions section.

### 14. Confirm again: no docking yet.

**Context:** Docking is planned for a later phase (Phase 5) after structures are verified, residue numbering is mapped, ligands are validated, mutant models are generated, and pocket geometry is checked. No docking was run in Phase 2. This is a re-confirmation that docking should not begin in Phase 3.

**Source:** Project directive; `chatgpt_supervision/BIOMNI_OUTPUT_SUMMARY.md` boundary conditions section.
