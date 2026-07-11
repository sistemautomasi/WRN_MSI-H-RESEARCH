# Phase 2 Integrity Verification — Summary

**Verdict: NO HALLUCINATION DETECTED.** All 37 protein CIFs are bit-identical to fresh RCSB downloads. All 6 verifiable ligands match their canonical PubChem / RCSB CCD sources. Three ligands (SMILES-only sources) are flagged as unverifiable per project rule; two ligands are CCD-only references with no local SDF.

---

## 1. Purpose

Verify that every file collected in Phase 2 is a direct, unmodified download from a canonical public source (RCSB, PubChem). This rules out AI hallucination, silent corruption, or unauthorized modification of the source data before it enters the modeling pipeline.

## 2. Method

Three independent verification layers per protein CIF; content + provenance layers for ligands.

### Protein CIFs (37 files)
1. **MD5 bit-identity** — Download a fresh copy from `https://files.rcsb.org/download/<pdb_id>.cif`, compute md5 hashes on both local and fresh, require exact match.
2. **Coordinate hash** — Extract only `ATOM`/`HETATM` lines, hash them independently. Catches content-level modification even if metadata drifted.
3. **RCSB header signatures** — 8 orthogonal markers per file:
   - `data_<pdb_id>` block header matches filename
   - `_entry.id` matches filename
   - `_pdbx_audit_revision_history.revision_date` present (loop or key-value form)
   - `pdb_00000<id>` accession token present
   - `10.2210/pdb<id>/pdb` DOI present
   - WWPDB internal ID (`D_<digits>`) present
   - Crystallographic unit cell present
   - Atom count > 100

### Ligand SDFs (6 files)
- **RCSB CCD ligands** (YHC, YH8, X1L): MD5 vs fresh `https://files.rcsb.org/ligands/download/<CCD>_ideal.sdf`
- **Named compounds** (HRO761, VVD-214, GSK4418959): PubChem InChIKey lookup on parent structure

### Ligand SMILES-only (3 files)
- Flagged UNVERIFIED per project rule (source is internal DEL library, proprietary compound, or non-public alias — no canonical database record exists)

## 3. Results

### 3.1 Protein CIFs — 37/37 BIT_IDENTICAL

| Layer | Passed | Failed |
|---|---|---|
| MD5 hash match | 37/37 | 0/37 |
| Coordinate hash match | 37/37 | 0/37 |
| Header signatures (8/8) | 37/37 | 0/37 |

**Every one of the 37 CIFs is byte-for-byte identical to the current RCSB copy** — zero-byte size difference, matching md5, matching coordinate hash, matching all 8 RCSB header markers.

See `protein_integrity.csv` (37 rows × 12 columns) and `header_integrity.csv` (37 rows × 18 columns).

### 3.2 Ligand SDFs — 6/6 verified

| # | Ligand | File | Method | Verdict |
|---|---|---|---|---|
| 1 | HRO761 (CCD ligand) | `YHC_ideal_from_RCSB.sdf` | MD5 vs RCSB CCD | BIT_IDENTICAL |
| 2 | HRO761 analog (CCD ligand) | `YH8_ideal_from_RCSB.sdf` | MD5 vs RCSB CCD | BIT_IDENTICAL |
| 3 | VVD-214 covalent adduct (CCD ligand) | `X1L_ideal_from_RCSB.sdf` | MD5 vs RCSB CCD | BIT_IDENTICAL |
| 4 | HRO761 (parent) | `HRO761.sdf` | PubChem CID 166140536 | VERIFIED_MULTI_SOURCE |
| 5 | VVD-214 / RO-7589831 (parent) | `VVD-214.sdf` | PubChem InChIKey | VERIFIED_MULTI_SOURCE |
| 6 | GSK4418959 / IDE275 (parent) | `GSK4418959_IDE275.sdf` | PubChem CID 172618374 | VERIFIED_MULTI_SOURCE |

**All 6 SDFs have publicly verifiable identity.** InChIKey / md5 comparisons against canonical databases pass. See `ligand_integrity.csv` (11 rows × 19 columns).

### 3.3 Ligand SMILES-only — 3 UNVERIFIED_FLAGGED (per project rule)

| # | Ligand | File | Reason |
|---|---|---|---|
| 7 | SNV5686 | `SNV5686_NOT_PUBLICLY_VERIFIED.smiles.txt` | Non-public alias, no canonical database record |
| 8 | JJ_Compound_A_B_C | `JJ_CompoundABC_NOT_PUBLICLY_VERIFIED.smiles.txt` | Placeholder identifiers, internal J&J compounds |
| 9 | AbbVie_DEL_series | `AbbVie_DEL_series_NOT_PUBLICLY_VERIFIED.smiles.txt` | Proprietary DEL library, non-disclosed structures |

These files exist locally with `_NOT_PUBLICLY_VERIFIED` explicitly in their filenames. They are flagged in accordance with the project rule "excluded three-digit-suffix alias policy" and will not be used for docking or downstream modeling unless external verification becomes available.

### 3.4 CCD-only references — 2 NOT_SAVED_LOCALLY

| # | Ligand | Chain code | Reason |
|---|---|---|---|
| 10 | GSK5819992 | A1I5L | Referenced only via bound CCD chain code, no separate SDF collected |
| 11 | GSK4766470 | A1I5F | Same |

These are CCD chain codes present in bound structures but not extracted as standalone ligand SDFs. No hallucination risk (they are structural annotations, not modeled compounds).

## 4. Files in this folder

| File | Rows | Purpose |
|---|---|---|
| `protein_integrity.csv` | 37 | Per-CIF md5 + coordinate hash vs fresh RCSB |
| `ligand_integrity.csv` | 11 | Per-ligand verification (md5 / PubChem InChIKey / UNVERIFIED_FLAGGED) |
| `header_integrity.csv` | 37 | 8-marker RCSB header signature check |
| `integrity_summary.md` | — | This document |

## 5. Conclusion

**No hallucination or modification detected in Phase 2 protein or ligand data.**

- All 37 protein CIFs are bit-identical direct downloads from RCSB (triple-verified via md5, coordinate hash, and 8 header markers).
- All 6 verifiable ligand SDFs match their canonical database records (RCSB CCD md5 match or PubChem InChIKey match).
- 3 SMILES-only files are properly flagged UNVERIFIED_FLAGGED with `_NOT_PUBLICLY_VERIFIED` in filenames — they will not enter downstream modeling.
- 2 CCD-only references have no local ligand file (structural annotations only).

The Phase 2 data collection is verifiably faithful to canonical public sources.
