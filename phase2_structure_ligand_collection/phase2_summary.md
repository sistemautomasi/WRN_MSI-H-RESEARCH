# WRN Phase 2 — Summary

**Phase 2 objective:** Assemble a verified inventory of public WRN structures and ligands with residue-level mapping and Phase-1-cross-referenced inhibitor identifiers, without running docking, MD, mutant modeling, or virtual screening.

**Status:** All 13 planned steps executed. Outputs saved to `/mnt/results/wrn_resistance_project/phase2_structure_ligand_collection/`.

**Date completed:** 2026-07-07

---

## 1. What was done

1. Confirmed the UniProt Q14191 canonical WRN sequence (1432 aa) and residue identities at Phase 1 mutation positions: L528, C727, G729, F730, I852 — all match the Phase 1 panel exactly.
2. Enumerated all 51 public RCSB polymer entities cross-referenced to UniProt Q14191.
3. Applied a 3-stage filter:
   - Pre-filter excluded 10 classic 2005-2010 exonuclease-domain entries.
   - Metadata harvest excluded 2 non-helicase constructs (7XUT = fusion, 6TYV = peptide).
   - Coordinate-level residue mapping excluded 2 N-terminal / exonuclease-only entries (8YLE, 9HZG).
4. **37 helicase-domain WRN structures** retained as in-scope.
5. Downloaded 37 mmCIF files, all unmodified from RCSB.
6. Parsed `_struct_conn` LINK records for coordinate-level covalent-bond identification.
7. Mapped residues L528/C727/G729/F730/I852 in each structure via mmCIF `_atom_site` CA records, with numbering-scheme verification against UniProt Q14191.
8. Classified each entry into 6 conformational states: apo (2), nucleotide-bound (5), DNA-bound (1), inhibitor-bound (10), covalent-ligand-bound (10), fragment-bound (9).
9. Cross-referenced Phase 1 inhibitors (HRO761, VVD-214/RO7589831, GSK4418959/IDE275, SNV5686, J&J series, AbbVie DEL series) against PubChem, ChEMBL, and RCSB CCD via name-search + InChIKey / skeleton canonicalization (RDKit).
10. Saved verified inhibitor SDFs (RDKit-embedded 3D from PubChem canonical SMILES) plus SMILES text files for the 3 publicly verified compounds; explicit stubs for the 3 unverified.
11. Wrote 3 machine-readable inventories (CSV) and 5 human-readable documents (Markdown).

## 2. Key findings

### 2a. WRN structural coverage of resistance residues

Across the 37 in-scope structures, resistance residue coverage is **179/185 = 96.8%** (37 × 5 = 185 total residue mapping slots):
- **100% coverage** for C727, G729, F730, I852.
- **L528 missing** in 6 structures (9MJS, 9RTI, 9RUR, 9RUS, 9S17, 9S1A) — polymer construct start is downstream of L528.

### 2b. Covalent Cys727 chemistry

**10 entries** have coordinate-level covalent LINK records at Cys727-SG:
- **10AK, 10AP** (cyclic vinyl sulfone series, 2026)
- **7GQU** (VVD-214 covalent adduct = CCD X1L)
- **9OG8** (DEL-screen derived; bond distance 1.428 Å is anomalously short — see missing_data_report §3)
- **9QBU** (GSK5819992), **9QBV** (GSK4766470)
- **9RTI, 9RUR** (AI-assisted covalent series)
- **9S17** (molecule 81 from MSI-H WRN 2026 paper)
- **9S1B** (GSK_WRN3 covalent inhibitor)

No covalent-bond LINK records found at any other cysteine in the 37-structure set.

### 2c. Phase 1 inhibitor → cocrystal mapping

| Phase 1 inhibitor | Public cocrystal | Ligand CCD | Verification |
|---|---|---|---|
| HRO761 | 8PFO, 9S18 | YHC | Exact InChIKey (`XKYVECRUZPCRQR-UHFFFAOYSA-N`) |
| VVD-214 | 7GQU (covalent) | X1L | Skeleton match (covalent adduct form) |
| GSK4418959/IDE275 | none | none | PubChem-verified (CID 172618374); no public cocrystal |
| SNV5686 | none | none | Not publicly verified |
| J&J Compound A/B/C | none | none | Not publicly verified |
| AbbVie DEL series | possibly 9OG3/9OG8 | A1CA4, A1CA5 | Chemistry not matched by name — see missing_data_report §1c |

### 2d. Additional non-Phase-1 cocrystal ligands identified

- **YH8** (bound in 8PFL) = HRO761 analog 'compound 3' from Novartis paper (distinct InChIKey; MW 666 vs HRO761's 701).
- **GSK5819992** (bound in 9QBU) = GSK covalent series compound.
- **GSK4766470** (bound in 9QBV) = GSK covalent series compound.

## 3. Deliverables

```
phase2_structure_ligand_collection/
├── structure_inventory.csv           (37 rows × 35 columns)
├── residue_mapping_table.csv         (185 rows × 13 columns)
├── ligand_inventory.csv              (9 rows × 21 columns)
├── structure_selection_decision.md   (11 sections)
├── phase2_missing_data_report.md     (8 sections)
├── phase2_user_verification_checklist.md (13 items)
├── phase2_summary.md                 (this file)
├── phase2_execution_log.md           (reproducibility log)
├── protein_structure_files/          (37 mmCIF files, 32.3 MB total)
└── ligand_structure_files/           (12 files)
     ├── HRO761.sdf, HRO761.smiles.txt (RDKit 3D from PubChem)
     ├── VVD-214.sdf, VVD-214.smiles.txt
     ├── GSK4418959_IDE275.sdf, GSK4418959_IDE275.smiles.txt
     ├── YHC_ideal_from_RCSB.sdf, YH8_ideal_from_RCSB.sdf, X1L_ideal_from_RCSB.sdf
     └── SNV5686_NOT_PUBLICLY_VERIFIED.smiles.txt, JJ_Compound_A_B_C_NOT_PUBLICLY_VERIFIED.smiles.txt, AbbVie_DEL_series_NOT_PUBLICLY_VERIFIED.smiles.txt
```

## 4. Boundary conditions respected

- **NO docking or virtual screening was run.**
- **NO molecular dynamics simulations were run** (MD is on hold per project directive).
- **NO mutant models were generated.**
- **NO binding affinity predictions were made.**
- **NO coordinates were altered.** All mmCIF files in `protein_structure_files/` are unmodified RCSB downloads.
- **NO invented data.** Every value in the CSVs traces to a specific REST API response, mmCIF field, or RDKit canonicalization.

## 5. Known limitations

1. **3 of 6 Phase 1 inhibitors could not be linked to public 3D structures.** SNV5686, J&J series, AbbVie DEL series — cannot be modeled from public data alone.
2. **L528 missing in 6/37 structures.** Coordinate coverage: 179/185 = 96.8%.
3. **9OG8 covalent bond distance is anomalously short (1.428 Å).** Data-quality flag; template should be visually inspected before use.
4. **A1CA4/A1CA5 (in 9OG3/9OG8) compound naming not resolved to abstract-level compound codes.** Requires Tong et al. 2025 J Med Chem full text.
5. **PubChem 'GSK4418959' returned two enantiomer CIDs** (172618374 primary + 172618744) — both preserved in ligand_inventory.csv but this makes the CID field a compound string, not a pure integer.

## 6. Highlights for Phase 3 planning

**Best templates by state (technical ranking based on resolution + residue coverage):**

- **Best apo WT reference:** 9MJT (X-ray, 1.73 Å, all 5 residues resolved)
- **Best nucleotide-bound (ATPase-site):** 9MJS (1.84 Å AMPPNP), 6YHR (2.2 Å ADP), 8PFP (1.6 Å ATP-γ-S / CCD AGS)
- **Best HRO761 non-covalent cocrystal:** 8PFO (1.9 Å, YHC = HRO761 exactly)
- **Best VVD-214 covalent cocrystal:** 7GQU (X1L covalent adduct at C727)
- **Best DNA-bound reference:** 9S19 (2.3 Å)
- **Best resolution covalent Cys727 template:** 10AK (1.37 Å, all 5 residues)
- **Best 2026 covalent template with all 5 residues:** 9S1B (2.22 Å, GSK_WRN3)

**Ligand templates ready for Phase 3:**
- HRO761 SDF (49 atoms with 3D coordinates)
- VVD-214 SDF (30 atoms)
- GSK4418959 SDF (45 atoms)
- YHC, YH8, X1L RCSB ideal SDFs (crystallographic coordinates)

## 7. What would need to happen before Phase 3

1. User verification pass through the 13-item checklist.
2. User decision on which of the 7 resistance mutations to model in Phase 3.
3. User selection of primary template(s) per state (defaults suggested in §6 above; but user may prefer other choices).
4. User confirmation that MD remains on hold (per project constraint).
5. User confirmation that Phase 3 workflow (mutant model generation) may commence.

## 8. Explicit stop condition

Per project rule, Phase 2 stops here. Phase 3 will NOT begin without explicit user authorization.