# Phase 2 — Structure and Ligand Collection

## Objective

Build a verified inventory of public WRN helicase-domain structures, bound ligands, and residue-level mappings for the resistance-relevant positions (L528, C727, G729, F730, I852).

## Status

**Completed** — 37 structures, 9 ligands, 185 residue mappings. All 11 acceptance checks pass.

## Deliverables

### Data tables (CSV)
- `structure_inventory.csv` — 37 rows × 35 columns (all in-scope WRN helicase-domain PDB entries)
- `residue_mapping_table.csv` — 185 rows × 13 columns (L528/C727/G729/F730/I852 per chain per PDB)
- `ligand_inventory.csv` — 9 rows × 21 columns (verified inhibitors + not-publicly-verified compounds)

### Structure files
- `protein_structure_files/` — 37 mmCIF files (~32 MB, originals unmodified from RCSB)
- `ligand_structure_files/` — 12 files (SDF + SMILES for verified ligands, stubs for unverified)

### Documentation (Markdown)
- `structure_selection_decision.md` — Inclusion/exclusion rationale for all 51 candidate entries
- `phase2_missing_data_report.md` — Every gap, unverified compound, data-quality flag
- `phase2_user_verification_checklist.md` — 13-item review checklist
- `phase2_summary.md` — 8-section methods + findings + boundary conditions
- `phase2_execution_log.md` — Software versions, REST endpoints, error resolution log

## Key Findings

- **37 in-scope structures** (from 51 RCSB entries; 14 excluded — 10 exonuclease-domain, 4 fragment/fusion)
- **State distribution:** 10 non-covalent inhibitor, 10 covalent (all at Cys727), 9 fragment, 5 nucleotide, 2 apo, 1 DNA-bound
- **Residue coverage:** 179/185 = 96.8% (L528 missing in 6 structures due to N-terminal truncation)
- **10 covalent Cys727 cocrystals** with verified S–C distances (1.428–1.824 Å; 9OG8 at 1.428 Å flagged as anomalously short)
- **3 verified inhibitors** with PubChem CID + RCSB CCD + InChIKey cross-match: HRO761, VVD-214, GSK4418959
- **3 not-publicly-verified compounds:** SNV5686, Janssen series, AbbVie DEL series

## Boundary Conditions

- No docking, MD, virtual screening, mutant models, or binding affinity claims
- All numbering = UniProt Q14191 canonical
- All claims traceable to RCSB REST API responses or coordinate-level parses
