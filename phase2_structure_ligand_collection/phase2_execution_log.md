# WRN Phase 2 — Execution Log (Reproducibility)

**Purpose:** Complete methodological trace of every step executed in Phase 2, sufficient for a third party to reproduce the outputs.

**Execution date:** 2026-07-07

**Working directory:** `/workspace/wrn_phase2_structures/`
**Output directory:** `/mnt/results/wrn_resistance_project/phase2_structure_ligand_collection/`

---

## Software versions

- Python 3.13
- Biopython (`Bio.PDB`, `Bio.pairwise2`) — pre-installed
- RDKit — pre-installed
- gemmi 0.7.5 (installed during execution via `uv pip install gemmi==0.7.5`)
- requests — pre-installed
- pandas — pre-installed

## REST API endpoints used

| Purpose | Endpoint |
|---|---|
| UniProt entry | `GET https://rest.uniprot.org/uniprotkb/Q14191.json` |
| UniProt FASTA | `GET https://rest.uniprot.org/uniprotkb/Q14191.fasta` |
| RCSB Search API (polymer_entity) | `POST https://search.rcsb.org/rcsbsearch/v2/query` |
| RCSB entry metadata | `GET https://data.rcsb.org/rest/v1/core/entry/{pdb_id}` |
| RCSB polymer_entity metadata | `GET https://data.rcsb.org/rest/v1/core/polymer_entity/{pdb_id}/{entity_id}` |
| RCSB non-polymer entity | `GET https://data.rcsb.org/rest/v1/core/nonpolymer_entity/{pdb_id}/{entity_id}` |
| RCSB chem_comp / CCD | `GET https://data.rcsb.org/rest/v1/core/chemcomp/{ccd_id}` |
| RCSB mmCIF file download | `GET https://files.rcsb.org/download/{pdb_id}.cif` |
| RCSB CCD ideal SDF | `GET https://files.rcsb.org/ligands/download/{ccd_id}_ideal.sdf` |
| PubChem name → CID | `GET https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/{name}/cids/JSON` |
| PubChem CID → properties | `GET https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/{cid}/property/SMILES,IUPACName,MolecularWeight,MolecularFormula/JSON` |
| ChEMBL molecule search | `GET https://www.ebi.ac.uk/chembl/api/data/molecule/search.json?q={name}&limit=N` |

**All queries used HTTPS. No credentials were required (all public read-only endpoints). Rate-limiting was voluntarily respected with a 0.1-0.3 s delay between successive RCSB calls.**

## Execution steps (13 total)

### Step 1 — Folder setup

```
mkdir -p /mnt/results/wrn_resistance_project/phase2_structure_ligand_collection/{protein_structure_files,ligand_structure_files}
mkdir -p /workspace/wrn_phase2_structures/cif
mkdir -p /workspace/wrn_phase2_structures/ligand_files
```

### Step 2 — UniProt anchor

- Fetched `https://rest.uniprot.org/uniprotkb/Q14191.json`
- Confirmed sequence length = 1432 aa
- Verified residues at positions 528 (L), 727 (C), 729 (G), 730 (F), 852 (I)
- Saved FASTA: `WRN_Q14191_canonical.fasta`

### Step 3 — RCSB entity enumeration

POST body to RCSB Search API:

```json
{
  "query": {
    "type": "terminal",
    "service": "text",
    "parameters": {
      "attribute": "rcsb_polymer_entity_container_identifiers.reference_sequence_identifiers.database_accession",
      "operator": "exact_match",
      "value": "Q14191"
    }
  },
  "return_type": "polymer_entity",
  "request_options": {"paginate": {"start": 0, "rows": 200}}
}
```

**Result:** 51 polymer entities returned. Applied Stage A exclusion (10 classic exonuclease PDBs). Retained 41 for metadata harvest.

**Raw enumeration saved:** `rcsb_entity_search_raw.json`

### Step 4 — Metadata harvest

For each of the 41 candidate PDB IDs, made 3 API calls:
1. `/rest/v1/core/entry/{pdb}` — top-level metadata
2. `/rest/v1/core/polymer_entity/{pdb}/1` — polymer chain composition
3. `/rest/v1/core/nonpolymer_entity/{pdb}/{np_id}` for each non-polymer ID — ligand names

Applied Stage B exclusion: 7XUT (RPA70N fusion), 6TYV (13-residue Ku-binding peptide). Retained 39.

**Raw metadata saved:** `rcsb_metadata_raw.json`

### Step 5 — mmCIF download

For each of the 39 in-scope PDBs, downloaded `https://files.rcsb.org/download/{pdb}.cif` to `/workspace/wrn_phase2_structures/cif/`, then copied to `/mnt/results/.../protein_structure_files/`.

Total size: 32.3 MB (range 437 KB - 3.3 MB per file). Zero download errors.

### Step 6 — LINK-record covalent-bond parse

For each of the 39 mmCIF files, parsed `_struct_conn` records via gemmi. Filtered to records with `conn_type_id == "covale"` connecting a Cys SG atom to a non-polymer ligand atom.

**Result:** 10 entries with covalent LINK records at Cys727 (all at Cys727, none at other cysteines).

**Raw LINK records saved:** `link_records_all.json`

### Step 7 — Residue mapping via mmCIF _atom_site + Bio.pairwise2

For each of the 39 mmCIF files:
1. Extracted all CA atoms from mmCIF via gemmi.
2. Built a per-chain WRN sequence string.
3. Ran pairwise alignment against UniProt Q14191 canonical.
4. For each of positions {528, 727, 729, 730, 852}, checked whether the auth_seq_id in the mmCIF matches the canonical position and identity.

**Result:** 2 further exclusions: 8YLE (residues 9-428, N-terminal / exo domain), 9HZG (residues 12-231, Ku-WRN-exo complex). Retained 37 in-scope.

**Auth_seq_id numbering matches UniProt canonical in 100% of retained entries.**

**Raw mapping saved:** `residue_maps.json`

### Step 8 — State classification

Applied a rule-based classifier:
1. Identify all non-polymer entities per structure.
2. Filter out common non-inhibitors (ions, buffers, cryoprotectants, waters).
3. Check for polynucleotide entity (state = DNA-bound).
4. Check for covalent-LINK at C727 (state = covalent-ligand-bound).
5. Check for nucleotide ligand (ADP/ATP/AMPPCP/AMPPNP/ATPgS; state = nucleotide-bound).
6. Check for MW > 300 non-nucleotide drug-like ligand (state = inhibitor-bound or fragment-bound, based on ligand size and paper citation).
7. Otherwise (state = apo).

**Distribution:** 10 covalent / 10 inhibitor-bound / 9 fragment-bound / 5 nucleotide / 2 apo / 1 DNA-bound.

**Saved:** `structure_state_classifications.json`

### Step 9 — Phase 1 inhibitor verification

For each of the 6 Phase 1 inhibitors:
1. Query PubChem name→CID.
2. If CID(s) returned, query PubChem for canonical SMILES + InChIKey + MW.
3. Query ChEMBL molecule/search for cross-reference.
4. Compute RDKit canonical SMILES + first-14 InChIKey.

For each of the 37 in-scope structures' drug-like ligand CCDs (31 unique):
1. Fetch RCSB CCD metadata (chem_comp) — fields `SMILES`, `SMILES_stereo`, `InChI`, `InChIKey`.
2. Compute RDKit canonical SMILES + first-14 InChIKey.

**Cross-match rule:** exact InChIKey (14-char, full) = strong match; first-14-char match = skeleton match.

**Matches identified:**
- **YHC == HRO761** (exact InChIKey `XKYVECRUZPCRQR-UHFFFAOYSA-N`)
- **X1L skeleton-matches VVD-214** (first-14 `DBNMEVJJGIPVCE`; X1L is the reduced covalent adduct form)
- **YH8** is a distinct HRO761 analog (different InChIKey `FLRLAYBOOSONEK`)
- **A1CA4, A1CA5, A1I5L, A1I5F** are distinct compounds (no match to GSK4418959)

**Saved:** `phase1_inhibitor_verification.json`, `phase1_ccd_matches.json`, `ccd_ligand_metadata.json`

### Step 10 — Save ligand SDF files

For each of the 3 verified Phase 1 inhibitors (HRO761, VVD-214, GSK4418959):
- Wrote canonical SMILES text file (`{name}.smiles.txt`).
- Used RDKit to generate 3D coordinates via `AllChem.EmbedMolecule` + `AllChem.MMFFOptimizeMolecule` (default parameters).
- Saved as `{name}.sdf` via `Chem.SDWriter`.

For the 3 RCSB CCD ideal SDFs (YHC, YH8, X1L): downloaded via `https://files.rcsb.org/ligands/download/{ccd}_ideal.sdf` (unmodified).

For the 3 unverified inhibitors (SNV5686, J&J, AbbVie): wrote explanatory stub files named `*_NOT_PUBLICLY_VERIFIED.smiles.txt`.

**Total:** 12 files in `ligand_structure_files/`.

### Step 11 — Build 3 CSV inventories

Assembled `structure_inventory.csv` (37 rows), `residue_mapping_table.csv` (185 rows), `ligand_inventory.csv` (9 rows). Every cell derived from an earlier step's JSON artifact.

**Sanity checks:**
- All 3 CSVs re-load cleanly via `pandas.read_csv`.
- Structure_inventory has 100% coverage of `source_database_url_or_identifier` and `validated_source` columns.
- Residue mapping is 179/185 = 96.8% correct.
- No `GSK959` grep hits in the delivered data tables (`structure_inventory.csv`, `residue_mapping_table.csv`, `ligand_inventory.csv`). The term may still appear in audit prose where the alias-exclusion check itself is documented.

### Step 12 — Markdown deliverables

Wrote 5 markdown files summarizing selection decisions, missing data, verification checklist, phase summary, and this execution log.

### Step 13 — Acceptance checklist and stop

Run 11-item acceptance checklist per PLAN.md §16. Stop with the required phrase.

---

## Error resolution log

1. **`gemmi` ModuleNotFoundError** during Step 6 → resolved with `uv pip install gemmi==0.7.5`.
2. **RCSB CCD API `smiles`/`smilesstereo` returning None** — wrong lowercase field names. Fields are actually `SMILES`, `SMILES_stereo`, `InChI`, `InChIKey` (uppercase-leading). Corrected in Step 9 and 35 CCDs re-fetched successfully.
3. **Live RCSB enumeration returned 51 entities vs earlier session's 50** — new entry 9S1B released 2026-05-27 (WRN helicase in complex with covalent inhibitor GSK_WRN3). Verified via direct RCSB entry query and included in-scope.
4. **`Chem.Descriptors` AttributeError** — wrong import path; fixed by `from rdkit.Chem import Descriptors`.
5. **8YLE and 9HZG residue ranges** — only revealed at Step 7 (coordinate-level check), not at earlier metadata-only stages. Documented in exclusion log.

## Intermediate JSON artifacts (execution-time working directory)

These artifacts were generated in `/workspace/wrn_phase2_structures/` during the original Phase 2 run. They are listed here for reproducibility, but they are not part of the versioned repository handoff unless separately copied into the project workspace:

- `rcsb_entity_search_raw.json`
- `rcsb_metadata_raw.json`
- `link_records_all.json`
- `residue_maps.json`
- `structure_state_classifications.json`
- `phase1_inhibitor_verification.json`
- `phase1_ccd_matches.json`
- `ccd_ligand_metadata.json`
- `in_scope_pdbs.json`
- `exclusion_log.json`
- `WRN_Q14191_canonical.fasta`
- `cif/*.cif` (39 files including 2 later-excluded)
- `ligand_files/*` (staging)

## What Phase 2 did NOT do (bounded scope)

- Did NOT run docking.
- Did NOT run MD simulations.
- Did NOT generate any mutant models.
- Did NOT alter any coordinates.
- Did NOT predict any binding affinities.
- Did NOT search compound libraries.
- Did NOT run any prediction/inference model.