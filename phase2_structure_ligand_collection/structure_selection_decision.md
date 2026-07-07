# WRN Phase 2 — Structure Selection Decision

**Scope:** Inventory of public WRN helicase-domain structures in RCSB, filtered to entries usable as templates for Phase 3-4 resistance-mutation modeling (positions L528, C727, G729, F730, I852 in the UniProt Q14191 canonical 1432-aa sequence).

**Numbering scheme:** UniProt Q14191 canonical (1432 aa). Every mmCIF's `auth_seq_id` was verified to match this canonical numbering; zero offset issues found across 37 in-scope entries.

**Date:** 2026-07-07

---

## 1. Search strategy

RCSB Search API (https://search.rcsb.org/rcsbsearch/v2/query) queried on `reference_sequence_identifiers.database_accession = Q14191`, return_type `polymer_entity`. **51 total WRN polymer entities** returned (as of 2026-07-07). Every entry's metadata harvested via RCSB Data API. Every mmCIF downloaded and parsed with gemmi for coordinate-level verification.

## 2. Filter rule set (post-verification)

**Retention rule:** entry (a) deposited 2020 or later, (b) whose crystallized polymer includes at least the helicase core (approximately residues 500-946 of Q14191), and (c) whose polymer entity is WRN itself (not a fusion, not a peptide fragment, not a partner protein with only a WRN motif).

**Applied in three stages:**

### Stage A — Pre-filter (metadata-based, 10 entries excluded)

10 classic 2005-2010 WRN exonuclease-domain crystal structures excluded because none of the resistance residues 528/727/729/730/852 sit in the exonuclease domain:

`2AXL, 2DGZ, 2E1E, 2E1F, 2FBT, 2FBV, 2FBX, 2FBY, 2FC0, 3AAF`

### Stage B — Post-metadata harvest (2 further exclusions)

After harvesting per-entry metadata, two entries were flagged as non-helicase WRN structures:

| PDB | Reason |
|---|---|
| `7XUT` | RPA70N-WRN fusion protein, 140 aa total polymer; WRN component is the N-terminal peptide only, no helicase domain |
| `6TYV` | Ku80 vWA domain crystallized with only a 13-residue WRN peptide (WRN residues 1400-1412, sequence `TTAQQRKCPEWMN` from the extreme C-terminus / Ku-binding motif). No helicase domain. |

### Stage C — Post-coordinate residue check (2 further exclusions)

After coordinate-level residue mapping (Step 7), two entries revealed as WRN N-terminal / exonuclease domain only:

| PDB | Reason |
|---|---|
| `8YLE` | WRN residues 9-428 crystallized. Despite RCSB title 'Werner syndrome helicase complexed with AMP-PCP', the crystallized region is the N-terminal / exonuclease domain, not the helicase core. No resistance residues present. |
| `9HZG` | Ku70/80 bound to WRN-exo (WRN residues 12-231). Confirmed by paper title 'Structural basis of Ku-mediated activation of WRN exonuclease activity'. No helicase domain, no resistance residues. |

### User-requested critical inclusion

**`10AJ`, `10AK`, `10AP`** — flagged by the user as 2026 human WRN helicase inhibitor/cocrystal structures from the paper 'Design of Cyclic Vinyl Sulfones as WRN Covalent Inhibitors from Noncovalent Binders'. All three verified against RCSB primary data (deposit 2026-01-08, release 2026-05-13) and INCLUDED in the in-scope list.

> **Important disambiguation:** `10AJ / 10AK / 10AP` = digit-1 + digit-0 + A + J/K/P (i.e., 'one-zero-A-J', not 'one-letter-O-A-J'). `1OAJ` (one-O-A-J) is a different, unrelated structure and is NOT in scope.

### Final in-scope count: **37 helicase-domain WRN structures** (out of 51 total).

## 3. In-scope structures — final list

| PDB | Method | Res (Å) | Deposit | State | Key ligand |
|---|---|---|---|---|---|
| 6YHR | X-RAY DIFFRACTION | 2.2 | 2020-03-30 | nucleotide-bound | nan |
| 8PFL | X-RAY DIFFRACTION | 1.8 | 2023-06-16 | inhibitor-bound | YH8 |
| 8PFO | X-RAY DIFFRACTION | 1.9 | 2023-06-16 | inhibitor-bound | YHC |
| 8PFP | X-RAY DIFFRACTION | 1.6 | 2023-06-16 | nucleotide-bound | nan |
| 7GQS | X-RAY DIFFRACTION | 1.57 | 2023-10-19 | nucleotide-bound | nan |
| 7GQT | X-RAY DIFFRACTION | 2.21 | 2023-10-19 | nucleotide-bound | nan |
| 7GQU | X-RAY DIFFRACTION | 1.54 | 2023-10-19 | covalent-ligand-bound | X1L |
| 9MK0 | X-RAY DIFFRACTION | 1.89 | 2024-12-16 | fragment-bound | A1BL7 |
| 9MK1 | X-RAY DIFFRACTION | 2.12 | 2024-12-16 | fragment-bound | A1BL8 |
| 9MJZ | X-RAY DIFFRACTION | 1.7 | 2024-12-16 | fragment-bound | A1BL6 |
| 9MJY | X-RAY DIFFRACTION | 1.63 | 2024-12-16 | fragment-bound | A1BL0 |
| 9MJW | X-RAY DIFFRACTION | 2.0 | 2024-12-16 | fragment-bound | A1BL3 |
| 9MJV | X-RAY DIFFRACTION | 2.58 | 2024-12-16 | fragment-bound | A1BL2 |
| 9MJX | X-RAY DIFFRACTION | 1.73 | 2024-12-16 | fragment-bound | A1BL4;A1BL5 |
| 9MJT | X-RAY DIFFRACTION | 1.73 | 2024-12-16 | apo | nan |
| 9MJS | X-RAY DIFFRACTION | 1.84 | 2024-12-16 | nucleotide-bound | nan |
| 9MJU | X-RAY DIFFRACTION | 1.579 | 2024-12-16 | fragment-bound | A1BL1 |
| 9QBV | X-RAY DIFFRACTION | 2.15 | 2025-03-03 | covalent-ligand-bound | A1I5F |
| 9QBU | X-RAY DIFFRACTION | 2.1 | 2025-03-03 | covalent-ligand-bound | A1I5L |
| 9OG3 | X-RAY DIFFRACTION | 2.06 | 2025-04-30 | inhibitor-bound | A1CA4 |
| 9OG8 | X-RAY DIFFRACTION | 1.66 | 2025-04-30 | covalent-ligand-bound | A1CA5 |
| 9OWD | X-RAY DIFFRACTION | 1.96 | 2025-06-02 | inhibitor-bound | A1CEZ |
| 9OWC | X-RAY DIFFRACTION | 1.67 | 2025-06-02 | inhibitor-bound | A1CEY |
| 9OWB | X-RAY DIFFRACTION | 1.56 | 2025-06-02 | inhibitor-bound | A1CEX |
| 9OW9 | X-RAY DIFFRACTION | 2.34 | 2025-06-02 | inhibitor-bound | A1CEV |
| 9OWA | X-RAY DIFFRACTION | 1.98 | 2025-06-02 | inhibitor-bound | A1CEW |
| 9RTI | X-RAY DIFFRACTION | 2.197 | 2025-07-02 | covalent-ligand-bound | A1JJ8;A1JJQ;MLT |
| 9RUR | X-RAY DIFFRACTION | 2.296 | 2025-07-04 | covalent-ligand-bound | A1JJK |
| 9RUS | X-RAY DIFFRACTION | 2.193 | 2025-07-04 | fragment-bound | GQP |
| 9S19 | X-RAY DIFFRACTION | 2.3 | 2025-07-18 | DNA-bound | nan |
| 9S17 | X-RAY DIFFRACTION | 1.91 | 2025-07-18 | covalent-ligand-bound | A1JKV |
| 9S18 | X-RAY DIFFRACTION | 1.995 | 2025-07-18 | inhibitor-bound | YHC |
| 9S1B | X-RAY DIFFRACTION | 2.218 | 2025-07-18 | covalent-ligand-bound | A1JKU |
| 9S1A | X-RAY DIFFRACTION | 1.956 | 2025-07-18 | apo | nan |
| 10AP | X-RAY DIFFRACTION | 2.58 | 2026-01-08 | covalent-ligand-bound | A1C4O |
| 10AK | X-RAY DIFFRACTION | 1.37 | 2026-01-08 | covalent-ligand-bound | A1C4L |
| 10AJ | X-RAY DIFFRACTION | 2.42 | 2026-01-08 | inhibitor-bound | A1C4J |

## 4. Conformational state distribution

| State | Count | Meaning for Phase 3 |
|---|---|---|
| covalent-ligand-bound | 10 | Covalently bonded inhibitor at Cys727; primary templates for C727-mutant modeling |
| inhibitor-bound | 10 | Non-covalent inhibitor pocket occupied; templates for allosteric-site and pocket geometry |
| fragment-bound | 9 | Fragment or fragment-derived compound; useful for pocket topology of allosteric hotspots |
| nucleotide-bound | 5 | ATP/ADP/AMPPNP/ATPgS in ATPase site; reference states for catalytic conformation |
| DNA-bound | 1 | Polynucleotide substrate present; reference for DNA-bound helicase conformation |
| apo | 2 | No ligand or nucleotide; unliganded reference states |

## 5. Covalent Cys727 cocrystals (from mmCIF LINK-record parse)

Ten in-scope entries have coordinate-level covalent bonds between Cys727 SG and a ligand atom. All bonds are at Cys727 exclusively; no other Cys residues in the helicase domain (C519, C623, C724, C1041) form covalent bonds with any ligand in the current cocrystals.

| PDB | CCD | Distance (Å) | Ligand identity |
|---|---|---|---|
| 10AK | A1C4L | 1.775 / 1.790 | Cyclic vinyl sulfone (2026 paper) |
| 10AP | A1C4O | 1.738 | Cyclic vinyl sulfone with 2-hydroxypropan-2-yl-pyridine (2026 paper) |
| 7GQU | X1L | 1.820 / 1.807 | VVD-214 covalent adduct (Vividion vinyl sulfone; Palte 2022) |
| 9OG8 | A1CA5 | 1.428 | DEL-screen derived covalent inhibitor (compound 43); short distance may reflect refinement quirk |
| 9QBU | A1I5L | 1.798 / 1.785 | GSK5819992 (GSK series) |
| 9QBV | A1I5F | 1.805 | GSK4766470 (GSK series) |
| 9RTI | A1JJ8 | 1.812 | AI-assisted delivery series (2026) |
| 9RUR | A1JJK | 1.819 | AI-assisted delivery series (2026) |
| 9S17 | A1JKV | 1.824 / 1.826 | Covalent 'molecule 81' from MSI-H WRN 2026 paper |
| 9S1B | A1JKU | 1.823 | GSK_WRN3 covalent inhibitor (2026 paper) |

**Note:** 9OG8 distance 1.428 Å is unusually short compared to the standard S–C covalent bond distance (~1.80 Å). This may reflect a refinement restraints setting or a modeled adduct-bond order that departs from a standard single bond. The bond identity as covalent is still supported by the LINK record type (`covale`) and the paper attribution, but the exact bond length should not be quoted as 'the covalent bond length' without further scrutiny.

## 6. Primary template recommendations (Phase 3 candidate templates)

The following recommendations rank structures by resolution and completeness of resistance residues. **Selection depends on Phase 3 modeling goals**, which have not been finalized. The full inventory (see §3) allows the user to make case-by-case template picks.

### 6a. Apo helicase reference (unliganded WT baseline)


| PDB | Res (Å) | 5 residues | Ligand | Score |
|---|---|---|---|---|
| 9MJT | 1.73 | all 5 | nan | 172.7 |
| 9S1A | 1.956 | 4 (no L528) | nan | 120.4 |

### 6b. Nucleotide-bound (ATPase-site reference)

| PDB | Res (Å) | 5 residues | Ligand | Score |
|---|---|---|---|---|
| 7GQS | 1.57 | all 5 | nan | 174.3 |
| 8PFP | 1.6 | all 5 | nan | 174.0 |
| 6YHR | 2.2 | all 5 | nan | 168.0 |

### 6c. Non-covalent inhibitor cocrystals (best pocket templates)

| PDB | Res (Å) | 5 residues | Ligand | Score |
|---|---|---|---|---|
| 9OWC | 1.67 | all 5 | A1CEY | 173.3 |
| 8PFL | 1.8 | all 5 | YH8 | 172.0 |
| 8PFO | 1.9 | all 5 | YHC | 171.0 |

### 6d. Covalent Cys727 cocrystals (C727 mutation modeling)

| PDB | Res (Å) | 5 residues | Ligand | Score |
|---|---|---|---|---|
| 10AK | 1.37 | all 5 | A1C4L | 176.3 |
| 7GQU | 1.54 | all 5 | X1L | 174.6 |
| 9OG8 | 1.66 | all 5 | A1CA5 | 173.4 |

### 6e. Fragment cocrystals (allosteric-pocket reference)

| PDB | Res (Å) | 5 residues | Ligand | Score |
|---|---|---|---|---|
| 9MJU | 1.579 | all 5 | A1BL1 | 174.2 |
| 9MJY | 1.63 | all 5 | A1BL0 | 173.7 |
| 9MJZ | 1.7 | all 5 | A1BL6 | 173.0 |

### 6f. DNA-bound reference

| PDB | Res (Å) | 5 residues | Ligand | Score |
|---|---|---|---|---|
| 9S19 | 2.3 | all 5 | nan | 162.0 |

**Ranking basis:** resolution (lower is better) + all 5 resistance residues resolved + X-ray preferred over EM + chain A preferred. This is a *technical* ranking, not a Phase 3 modeling decision.

## 7. Structures that lack L528 (6 entries)

The following in-scope entries have L528 outside the crystallized range (all other 4 residues C727/G729/F730/I852 present and correct):

`9MJS, 9RTI, 9RUR, 9RUS, 9S17, 9S1A`

These are usable for Phase 3-4 modeling of C727/G729/F730/I852 mutations but **cannot** support L528S mutation modeling directly. To model L528S from these templates would require extending the polymer through model building.

## 8. Numbering-scheme confirmation

All 37 in-scope structures use `auth_seq_id` numbering that matches UniProt Q14191 canonical numbering. Empirical verification: for every entry, the residue at auth_seq_id 528/727/729/730/852 matches the expected Q14191 canonical identity (L/C/G/F/I) — zero mismatches, zero offsets across 179/179 present-residue slots.

## 9. Public cocrystal ↔ Phase 1 inhibitor mapping

Of the 6 Phase 1 inhibitors, only 2 have public cocrystal structures in the current 37-entry set:

| Phase 1 inhibitor | RCSB CCD | PDB(s) | Verification |
|---|---|---|---|
| HRO761 (Novartis) | YHC | 8PFO, 9S18 | **Exact InChIKey match** to PubChem CID 166140536 |
| VVD-214 / RO-7589831 (Vividion) | X1L (covalent adduct form) | 7GQU | Skeleton match (InChIKey[:14]) — X1L is the reduced C-S single-bond form after Cys727 attack |
| GSK4418959 / IDE275 | — | — | PubChem-verified (CID 172618374); no public cocrystal |
| SNV5686 | — | — | Not publicly verified in PubChem/ChEMBL/RCSB |
| J&J Compound A/B/C | — | — | Not publicly verified |
| AbbVie DEL series | — | — | Not publicly verified |

Additional cocrystal ligands mapped from RCSB but not in the Phase 1 panel: HRO761 analog compound 3 (YH8 in 8PFL), GSK5819992 (A1I5L in 9QBU), GSK4766470 (A1I5F in 9QBV).

## 10. Data provenance & files

- **structure_inventory.csv** — 37 rows × 35 columns; every field derived from RCSB Data API responses (title, method, resolution, ligand IDs, chain composition) + coordinate-parsed LINK records (covalent bonds) + auth_seq_id-based residue mapping.
- **residue_mapping_table.csv** — 185 rows × 13 columns (37 structures × 5 resistance residues); every mapping cell derived from mmCIF _atom_site rows for CA atoms.
- **ligand_inventory.csv** — 9 rows × 21 columns; PubChem/ChEMBL/RCSB CCD cross-verified.
- **protein_structure_files/** — 37 mmCIF files (32.3 MB total; average ~875 KB each).
- **ligand_structure_files/** — 12 files: 3 verified inhibitor SDFs (RDKit-computed 3D) + 3 verified inhibitor SMILES text files + 3 RCSB CCD ideal SDFs (YHC, YH8, X1L; crystallographic ligand coordinates) + 3 not-publicly-verified stub text files (SNV5686, J&J, AbbVie).

## 11. What Phase 3 could do with this inventory

**Suggestions for Phase 3 template selection (not decisions, not commitments):**

- **WT baseline:** 9MJT (X-ray 1.73 Å, apo, all 5 residues) OR 6YHR (2.2 Å, ADP-bound, all 5 residues).
- **C727-mutation covalent modeling:** 9S1B (2.22 Å, GSK_WRN3, all 5 residues) — newly released and highest-quality covalent template; or 10AK (1.37 Å, cyclic vinyl sulfone, all 5 residues) at the very highest resolution.
- **L528 mutation modeling:** 8PFO (1.9 Å, HRO761, all 5 residues) — best resolution non-covalent template with all residues.
- **Comparative apo↔bound analysis:** 9MJT (apo) vs. 9S1B (covalent) vs. 8PFO (non-covalent HRO761) vs. 6YHR (ADP).
- **DNA-bound reference:** 9S19 (2.3 Å) — unique DNA-bound entry in current set.

None of the above have been executed. All are template *candidates*. Phase 3 template selection is out of scope for Phase 2.