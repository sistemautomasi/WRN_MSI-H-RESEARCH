# Biomni Output Summary: Phase 2

## Phase 2 output at a glance

| Metric | Value | Source |
|---|---|---|
| Total structures in `structure_inventory.csv` | 37 rows × 35 columns | `structure_inventory.csv` (verified by `pd.read_csv`) |
| Total rows in `residue_mapping_table.csv` | 185 rows × 13 columns | `residue_mapping_table.csv` (verified by `pd.read_csv`) |
| Total ligands in `ligand_inventory.csv` | 9 rows × 21 columns | `ligand_inventory.csv` (verified by `pd.read_csv`) |
| Residue coverage | 179 / 185 = 96.8% | `residue_mapping_table.csv` column `residue_present_and_correct` |
| Covalent Cys727 cocrystals | 10 | `structure_inventory.csv` column `covalent_link_at_cys` contains "727" |
| Conformational states | apo 2, nucleotide-bound 5, DNA-bound 1, inhibitor-bound 10, covalent-ligand-bound 10, fragment-bound 9 | `structure_inventory.csv` column `structure_state` |

## Key PDB templates recommended in phase2_summary.md

These are the templates recommended in `phase2_structure_ligand_collection/phase2_summary.md` §6, each verified against the actual `structure_inventory.csv` rows:

| Template role | PDB ID | Resolution (Å) | Key feature | Verified in CSV |
|---|---|---|---|---|
| Best apo WT reference | 9MJT | 1.73 | All 5 resistance residues present (L528, C727, G729, F730, I852) | ✓ |
| Best nucleotide-bound (AMPPNP) | 9MJS | 1.84 | ATP-site nucleotide | ✓ |
| Best nucleotide-bound (ADP) | 6YHR | 2.2 | ATP-site nucleotide | ✓ |
| Best nucleotide-bound (ATP-γ-S) | 8PFP | 1.6 | CCD AGS | ✓ |
| Best HRO761 non-covalent cocrystal | 8PFO | 1.9 | YHC = HRO761 (exact InChIKey match) | ✓ |
| Best VVD-214 covalent cocrystal | 7GQU | 1.54 | X1L covalent adduct at Cys727 (1.820 / 1.807 Å) | ✓ |
| Best DNA-bound reference | 9S19 | 2.3 | `has_polynucleotide = True` | ✓ |
| Best resolution covalent Cys727 template | 10AK | 1.37 | A1C4L covalent at Cys727, all 5 residues present | ✓ |
| Best 2026 covalent template with all 5 residues | 9S1B | 2.22 | GSK_WRN3 covalent inhibitor | ✓ |

## Verified Phase 1 inhibitors

Inhibitors with public chemical identifiers confirmed by PubChem CID, RCSB CCD, and/or InChIKey cross-match:

| Inhibitor | PubChem CID | RCSB CCD | Bound in PDB | Verification method |
|---|---|---|---|---|
| HRO761 | 166140536 | YHC | 8PFO, 9S18 | Exact InChIKey match (`XKYVECRUZPCRQR-UHFFFAOYSA-N`) |
| VVD-214 / RO-7589831 | 170717998 | X1L (covalent adduct) | 7GQU | Skeleton match (InChIKey first-14) — X1L is reduced vinyl sulfone form |
| GSK4418959 / IDE275 | 172618374 (+ 172618744 enantiomer) | none | none | PubChem-verified; no public cocrystal exists |
| HRO761 analog "compound 3" (YH8) | not searched (analog) | YH8 | 8PFL | RCSB CCD verified (same Novartis paper as HRO761) |
| GSK5819992 | not in PubChem by name | A1I5L | 9QBU | RCSB CCD verified (title: "(S)-27 (GSK5819992)") |
| GSK4766470 | not in PubChem by name | A1I5F | 9QBV | RCSB CCD verified (title: "(R)-11 (GSK4766470)") |

## Unverified / partially verified inhibitors

Inhibitors that could NOT be tied to a machine-readable public identifier (PubChem CID, ChEMBL ID, or RCSB CCD) using name-based cross-lookup:

| Inhibitor | Status | What is missing | Implication |
|---|---|---|---|
| SNV5686 | not publicly verified | No PubChem CID, no ChEMBL ID, no RCSB CCD, no SMILES. AACR 2025 abstract 2921 discloses activity vs WT + WRN-C727S but no chemistry. Sponsor not disclosed in abstract. | Cannot be modeled from public data. |
| J&J Compound A/B/C (Janssen) | not publicly verified | No PubChem CID, no ChEMBL ID, no RCSB CCD. Names too generic for name-search. | Cannot be modeled from public data. |
| AbbVie DEL series | not publicly verified (partial) | Ligand CCDs A1CA4 (in 9OG3) and A1CA5 (in 9OG8) exist in RCSB, but compound-name → CCD mapping is not resolved. SMILES do not match GSK4418959. | Ligand structures are in RCSB, but linkage to abstract-level compound codes requires Tong et al. 2025 J Med Chem full text. |

## Files created in Phase 2

All files are inside `phase2_structure_ligand_collection/`:

### Data tables (CSV)
1. `structure_inventory.csv` — 37 rows × 35 columns
2. `residue_mapping_table.csv` — 185 rows × 13 columns
3. `ligand_inventory.csv` — 9 rows × 21 columns

### Documentation (Markdown)
4. `structure_selection_decision.md` — inclusion/exclusion rationale for all 51 candidate entries
5. `phase2_missing_data_report.md` — every gap, unverified compound, data-quality flag
6. `phase2_user_verification_checklist.md` — 13-item review checklist
7. `phase2_summary.md` — 8-section methods + findings + boundary conditions
8. `phase2_execution_log.md` — software versions, REST endpoints, error resolution log

### Structure files
9. `protein_structure_files/` — 37 mmCIF files (~32 MB total, unmodified from RCSB)
10. `ligand_structure_files/` — 12 files:
    - `HRO761.sdf`, `HRO761.smiles.txt` (RDKit 3D from PubChem canonical SMILES)
    - `VVD-214.sdf`, `VVD-214.smiles.txt`
    - `GSK4418959_IDE275.sdf`, `GSK4418959_IDE275.smiles.txt`
    - `YHC_ideal_from_RCSB.sdf`, `YH8_ideal_from_RCSB.sdf`, `X1L_ideal_from_RCSB.sdf` (RCSB CCD ideal coordinates)
    - `SNV5686_NOT_PUBLICLY_VERIFIED.smiles.txt` (stub)
    - `JJ_Compound_A_B_C_NOT_PUBLICLY_VERIFIED.smiles.txt` (stub)
    - `AbbVie_DEL_series_NOT_PUBLICLY_VERIFIED.smiles.txt` (stub)

## Confirmation of boundary conditions

The following were NOT performed during Phase 2, consistent with the project directive:

- **No docking was run.** No `.pdbqt`, docking input, or docking-output files exist.
- **No molecular dynamics simulations were run.** No `.tpr`, `.gro`, `.top`, `.mdp`, `.dcd`, `.xtc`, `.trr` files exist. MD remains on hold.
- **No mutant models were generated.** The `phase3_mutant_model_generation/` folder contains only a placeholder `README.md` and was not modified in this task.
- **No virtual screening was performed.**
- **No binding-affinity predictions were made.**
- **No coordinates were altered.** All 37 mmCIF files are unmodified RCSB downloads.

These boundary conditions were verified by filesystem checks (no forbidden file extensions found anywhere in the repo) and by `git status` confirming only `chatgpt_supervision/` files were edited in this handoff task.
