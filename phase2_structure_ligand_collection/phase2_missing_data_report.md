# WRN Phase 2 — Missing Data, Assumptions, and Data-Quality Notes

**Purpose:** Track every gap, unverified inhibitor, and data-quality issue encountered while assembling the Phase 2 inventory. Provides transparency for the user's verification pass and for downstream phases.

**Scope note:** This document lists *what was NOT found or NOT verifiable* from public sources — as important as what was found.

---

## 1. Phase 1 inhibitors that could NOT be publicly verified

Of the 6 Phase 1 inhibitors, 3 could NOT be tied to a machine-readable public identifier (PubChem CID, ChEMBL ID, or RCSB CCD) using name-based cross-lookup in this session.

### 1a. SNV5686

- **Public information found:** Cited in an AACR 2025 abstract (Abstract 2921) by Liu P.C., Yang J., Ferrante D., et al. (Cancer Research 2025, DOI 10.1158/1538-7445.am2025-2921).
- **What abstract discloses:** SNV5686 is a differentiated WRN inhibitor with potent activity against both WT WRN and WRN-C727S mutant. Positioned as a potential best-in-class treatment for MSI-H tumors. Sponsoring organization NOT explicitly disclosed in the abstract text retrieved.
- **What was NOT found:**
    - No PubChem CID matches for the exact name 'SNV5686' in this session's PubChem name-search queries.
    - No ChEMBL entry.
    - No RCSB CCD ID or PDB entry.
    - No SMILES or structural chemistry disclosure in the abstract.
- **Status:** `not publicly verified` — 3D structural coordinates are not accessible from public sources at the time of Phase 2 execution.
- **Implication for Phase 3-4:** SNV5686 cannot be modeled with a public template because neither its 2D chemistry nor a cocrystal structure is available. If Phase 3 needs to include SNV5686, it will require either (a) the user providing SMILES from a non-public source, or (b) reliance on the C727S-active phenotype without the compound identity.

### 1b. J&J Compound A/B/C (Janssen)

- **Public information found:** Referenced by the Phase 1 curation as a Janssen (J&J) WRN inhibitor series associated with a Cys672-adjacent covalent site (per Phase 1 literature curation).
- **What was NOT found:**
    - No PubChem CID matches. Names too generic for name-search.
    - No ChEMBL entry.
    - No RCSB CCD ID or PDB entry.
- **Status:** `not publicly verified`
- **Implication:** Not modelable from public data in current form.

### 1c. AbbVie DEL series

- **Public information found:** Referenced in Phase 1 as an AbbVie DNA-encoded library (DEL) screening series of WRN inhibitors. The 2025 J Med Chem paper by Tong et al. (DOI 10.1021/acs.jmedchem.4c03029) 'Validation, Key Pharmacophores, and X-ray Cocrystal Structures of Novel Biochemically and Cellularly Active WRN Inhibitors Derived from a DNA-Encoded Library Screen' likely reports members of this series.
- **Cross-check to RCSB:** The 9OG3/9OG8 pair (deposit ~2024, release 2025) are almost certainly compounds from this DEL-screen paper. **Ligand CCDs A1CA4 (in 9OG3) and A1CA5 (in 9OG8) exist and were fetched from RCSB** — however their SMILES do NOT match GSK4418959 skeleton (InChIKey first-14 `BTOHHWKNNMWWQD` and `NHKXBVAOERUWNL` respectively — both distinct from `CPNRNECAIBPHJF` for GSK4418959).
- **Interpretation:** The 9OG3/9OG8 ligands are DEL-derived AbbVie inhibitors but *not* GSK4418959. The exact AbbVie compound names for A1CA4 and A1CA5 are NOT publicly resolved from RCSB CCD metadata alone; the Tong et al. 2025 J Med Chem paper text would need to be consulted for compound-name → CCD mapping.
- **Status:** ligand structures are in RCSB (SDF available), but linkage between AACR abstract compound codes ↔ CCD IDs is not established in this Phase 2 run.

## 2. Phase 1 inhibitors PubChem-verified but with NO public cocrystal

### 2a. GSK4418959 / IDE275

- **PubChem CID:** 172618374 (primary stereoisomer) + 172618744 (enantiomer). Both entries returned by PubChem name-search for 'GSK4418959' and cross-verified with the alias 'IDE275'.
- **Canonical SMILES:** `Cc1nc2cc(S(=O)(=O)N(C)c3ccc([C@H]4CCC[C@@H](C(=O)Nc5ccc(C(F)(F)F)cc5F)[C@@H]4C(=O)O)cc3)ccc2n1C` (obtained from PubChem CID 172618374)
- **InChIKey:** `CPNRNECAIBPHJF-MVOZIGHISA-N`
- **MW:** 646.19
- **Public cocrystal:** NONE found in RCSB. The 9QBU (CCD A1I5L) and 9QBV (CCD A1I5F) structures are titled 'in complex with (S)-27 (GSK5819992)' and 'in complex with (R)-11 (GSK4766470)' respectively — these are DIFFERENT GSK compounds (GSK5819992 and GSK4766470), NOT GSK4418959. SMILES / InChIKey comparison confirmed all four CCDs A1I5L, A1I5F, A1CA4, A1CA5 are distinct from GSK4418959.
- **Implication:** GSK4418959 chemistry is captured in `ligand_structure_files/GSK4418959_IDE275.sdf` (RDKit-embedded 3D from PubChem SMILES), but there is no crystallographic pose for it — Phase 3 docking or pose modeling for GSK4418959 would need to be *de novo* against a WRN template, not template-guided.

## 3. Data-quality note: 9OG8 covalent bond distance

The `_struct_conn` LINK record for 9OG8 (chain A) reports a S-C covalent bond distance of **1.428 Å** between Cys727-SG and the A1CA5 ligand acceptor atom. For reference, standard S-C single bond distances are approximately 1.80 Å, and other covalent Cys727-ligand distances in this dataset range 1.738-1.826 Å.

- **Observation:** 1.428 Å is unusually short and closer to a C=C double-bond distance (~1.33 Å) or a C=N distance (~1.28 Å) than an S-C single bond.
- **Possible explanations (not investigated in Phase 2):** (a) Non-standard restraint parameters during refinement of a strained covalent linkage; (b) mis-assignment of the acceptor atom to a shorter-distance neighbor in the LINK annotation; (c) genuine strained geometry in the crystal; (d) refinement artifact from occupancy < 1.
- **What was verified:** The LINK record type is `covale` and the linkage annotation identifies Cys727-SG as the donor atom. The bond type as *covalent* is not in question — only the *reported length* is anomalous.
- **Action for Phase 3:** If 9OG8 is selected as a template for covalent-inhibitor modeling, this bond distance should be visually inspected in a molecular viewer and cross-checked against the published paper (Tong et al. 2025 J Med Chem 10.1021/acs.jmedchem.4c03029) before relying on the coordinates.

## 4. L528 residue absent in 6 in-scope entries

The following 6 in-scope structures do NOT resolve L528 in the deposited coordinates because the crystallized polymer does not extend to residue 528:

`9MJS, 9RTI, 9RUR, 9RUS, 9S17, 9S1A`

All 6 do resolve C727/G729/F730/I852 correctly. Total residue-mapping coverage across the 37 in-scope structures is 179/185 = 96.8%. The remaining 6/185 slots (all L528) are missing due to polymer construct design, not due to poor electron density.

**Implication:** For L528S mutation modeling, use only structures where L528 is present (i.e., 31 of the 37). Recommended templates for L528S include 8PFO, 8PFP, 9MJT, 9MJU, 9MK0, 9MK1, 9OW9/9OWA/9OWB/9OWC/9OWD, 9OG3, 9OG8, 9QBU, 9QBV, 10AK, 10AP, 6YHR, 7GQS/7GQT/7GQU, 9S18, 9S19, 9S1B.

## 5. Exclusion log — structures NOT in the final 37

### 5a. Ten classic exonuclease-domain structures (2005-2010)
`2AXL, 2DGZ, 2E1E, 2E1F, 2FBT, 2FBV, 2FBX, 2FBY, 2FC0, 3AAF` — pre-filter exclusion. Every one of these crystallized the N-terminal WRN exonuclease domain only; the resistance residues (all in the helicase domain) are outside the polymer. Excluded before mmCIF download.

### 5b. Non-helicase WRN structures (metadata-based exclusion)

| PDB | Polymer detail | Exclusion reason |
|---|---|---|
| `7XUT` | RPA70N-WRN fusion protein, 140-aa polymer; UniProt cross-refs both P27694 (RPA70) and Q14191 (WRN). The WRN component is the N-terminal RPA-interacting region only, not the helicase domain. | Not a WRN helicase structure. |
| `6TYV` | Ku80 vWA domain (UniProt Q13070/Q6DDS9) crystallized with a 13-residue WRN peptide (WRN residues ~1400-1412 = extreme C-terminus / Ku-binding motif). | Peptide fragment far C-terminal to helicase domain; no resistance residues. |

### 5c. WRN N-terminal / exonuclease-domain-only structures (coordinate-level exclusion)

| PDB | WRN residue range in coordinates | Exclusion reason |
|---|---|---|
| `8YLE` | residues 9-428 | Despite RCSB title 'Werner syndrome helicase complexed with AMP-PCP', the crystallized WRN region is the N-terminal / exonuclease domain (residues 9-428). Helicase core residues (528, 727, 729, 730, 852) are absent. |
| `9HZG` | residues 12-231 | Ku70/80-WRN(exo) cryo-EM complex from the paper 'Structural basis of Ku-mediated activation of WRN exonuclease activity'. Only N-terminal WRN region. |

## 6. Metadata fields that were sparsely populated by RCSB

- **`reference_doi`:** Empty for many entries whose primary citation is in-press or whose DOI field was not populated in RCSB core metadata. Where empty, the citation title (`cite_title`) is provided in structure_inventory.csv as a fallback identifier.
- **`cite_year`:** Consistently populated when a primary citation exists; otherwise empty (as expected for entries whose paper is not yet published).
- **`assembly` details:** Not harvested in Phase 2 — only asymmetric-unit polymer_entity data was queried. If Phase 3 template selection needs to consider biological assembly vs. crystallographic packing, additional queries against `/rest/v1/core/assembly/{pdb}/{aid}` would be needed.

## 7. Assumptions that need user verification

1. **Helicase-domain scope (2020+):** The 10 exclusions in §5a assume that pre-2020 WRN entries in RCSB are all exonuclease-domain. Verified visually against RCSB titles but not against every mmCIF's atomic content.
2. **Numbering scheme:** All auth_seq_id values in the 37 in-scope entries have been coordinate-verified to match UniProt Q14191 canonical numbering. No entry uses an offset numbering scheme.
3. **Covalent-bond assignment:** Every 'covalent-ligand-bound' classification is backed by a `_struct_conn` LINK record with type `covale` connecting Cys727-SG to a ligand atom. No entries with covalent binding at other cysteines (C519/C623/C724/C1041) were identified in this run.
4. **HRO761 ↔ YHC identity:** Verified by exact InChIKey match (RDKit canonicalization). The MW difference (701.21 vs 702.08) is within normal formula-vs-monoisotopic tolerances.
5. **VVD-214 ↔ X1L identity:** Verified by skeleton match. X1L is the *reduced* form (S-CH2-CH2-Cys adduct), i.e., the covalent product of vinyl sulfone attack on Cys727-SH; the parent vinyl sulfone would have a C=C double bond that is absent in the crystallized covalent adduct. This is the *expected* chemistry outcome, not a mismatch.
6. **9OG3/9OG8 ↔ AbbVie/GSK naming:** The A1CA4 (9OG3) and A1CA5 (9OG8) ligands are distinct compounds; SMILES do not match any of the named Phase 1 inhibitors. The RCSB paper attribution (`Validation, Key Pharmacophores, and X-ray Cocrystal Structures of Novel Biochemically and Cellularly Active WRN Inhibitors Derived from a DNA-Encoded Library Screen`, Tong et al. 2025 J Med Chem) suggests these are AbbVie DEL-derived compounds. Compound-code disambiguation would require reading the paper.
7. **9QBU ↔ GSK5819992, 9QBV ↔ GSK4766470:** These identifications come directly from the RCSB title fields (`Crystal structure of WRN in complex with (S)-27 (GSK5819992)` and `Crystal structure of WRN in complex with (R)-11 (GSK4766470)`), not from PubChem cross-check (no matches for those exact names in PubChem name-search).

## 8. Data preservation guarantee

- All 37 mmCIF files in `protein_structure_files/` are unmodified originals from RCSB.
- No coordinates have been altered, edited, protonated, or refined.
- All ligand SDFs in `ligand_structure_files/` are either (a) RCSB CCD ideal SDFs (untouched) or (b) RDKit-generated 3D from the canonical SMILES retrieved from PubChem.
- No structural predictions have been made.
- No mutant models exist in Phase 2 — this is out of scope until Phase 3.