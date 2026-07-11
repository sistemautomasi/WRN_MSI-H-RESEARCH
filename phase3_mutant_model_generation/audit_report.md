# Extreme Audit Report — Phase 3 Wildtype Template Selection

**Audited artifact:** `wildtype_template_rationale.md` (justifying selection of 9MJT, 9S18, 7GQU, 9S19 from 37 Phase 2 WRN structures)

**Audit date:** 2026-07-11

**Rigor level:** Full paranoid audit — 3-source verification per claim, 5 cross-checks, strict 100% gate

**Verdict: PASS-WITH-CORRECTIONS → GO for Phase 4**

- 39 atomic claims scored across 8 categories (A–H).
- 37 PASSED first-pass verification.
- 2 required corrections; both applied in-place to `wildtype_template_rationale.md`.
- 0 unverifiable claims.
- All 5 cross-checks satisfied.
- No hallucinated ligands, no phantom PDB IDs, no invented mutation lists.

---

## 1. Method

Each claim in the rationale document was cross-checked against three independent sources:

| Source | Description | Path/URL |
|---|---|---|
| **Source 1** | Phase 2 CSV inventory | `structure_inventory.csv`, `residue_mapping_table.csv`, `ligand_inventory.csv` |
| **Source 2** | Direct mmCIF parse | 37 local CIFs via `gemmi.cif` — extracted `_reflns.d_resolution_high`, `_entity.pdbx_mutation`, `_struct_ref_seq_dif` (engineered mutation count), `_entity_poly.type`, `_pdbx_entity_nonpoly` (ligand CCDs), `_struct_conn` LINK records with covalent distances, `_citation` |
| **Source 3** | Live RCSB REST API | `data.rcsb.org/rest/v1/core/entry/{pdb}`, `polymer_entity/{pdb}/1`, `chemcomp/{ccd}` — verified resolution, mutation count, ligand CCD IUPAC names, deposit/release dates |

For a claim to PASS, all 3 sources had to agree. A single-source disagreement was scored MINOR (presentation) or FAIL (substantive).

Five cross-checks additionally probed the *selection logic itself*, not just the individual facts:

- **X1** — Resolution ranking per class (does the rationale correctly identify the highest-resolution structure?)
- **X2** — Alternative-template challenge (is there a strictly-better alternative on all criteria?)
- **X3** — Selection-rule closure (do the 4 templates satisfy all stated criteria?)
- **X4** — UniProt Q14191 numbering scheme validation
- **X5** — Ligand identity confirmation via RCSB CCD

---

## 2. Verdict Summary

| Verdict | Count | Meaning |
|---|---|---|
| **PASS** | 37 | Three sources agreed; claim stands as written |
| **PASS-AFTER-CORRECTION** | 2 | Original claim inaccurate; edited in place, re-verified, now PASS |
| **FAIL** | 0 | No unresolved failures |
| **UNVERIFIABLE** | 0 | No claims lacking evidence |

**Gate rule was: strict — 100% verification required.** Ledger meets it after 2 corrections.

---

## 3. Corrections Applied to `wildtype_template_rationale.md`

### 3.1 Correction 1 (was FAIL, now PASS) — Category E6

**Original claim (§3.3 Covalent class, selection sentence):**

> *"Selected: 7GQU — highest resolution (1.54 Å) among the 10, binds the actual Phase 1 clinical compound (VVD-214), no bond-length anomaly."*

**Audit finding:** 7GQU is **not** the highest resolution among the 10 covalent-class structures. 10AK (1.368 Å) is ~0.17 Å better. All 3 sources agree (structure_inventory.csv=1.368, mmCIF=1.368, RCSB API=1.37). This is a factually incorrect statement.

**Correction applied:** Rewrote the covalent-class table to include the true resolution ranking (10AK first at 1.37 Å, then 7GQU at 1.54 Å, etc.), and rewrote the selection sentence to:

> *"Selected: 7GQU — binds the actual Phase 1 clinical compound (VVD-214, cocrystal confirmed in Kikuchi et al. 2025 J Med Chem, DOI 10.1021/acs.jmedchem.5c01805), at 1.54 Å resolution, no bond-length anomaly. 10AK has higher resolution (1.37 Å) but binds a later cyclic-vinyl-sulfone chemotype (compound 4), not the clinical VVD-214. Because the resistance-mechanism question is chemotype-specific …, ligand identity is the primary selection axis in this class, not resolution."*

**Verification of correction:**
- 10AK ligand A1C4L = "N-benzyl-N-[(3R)-1,1-dioxo-1lambda~6~-thiolan-3-yl]-2-[4-(1H-pyrrol-1-yl)phenyl]acetamide" — cyclic vinyl sulfone from Kikuchi 2026 J Med Chem 6c00328 ("Design of Cyclic Vinyl Sulfones as WRN Covalent Inhibitors from Noncovalent Binders")
- X1L = VVD-214 confirmed by the VVD-214 discovery paper itself (Kikuchi et al. 2025 J Med Chem, PMC12751020): *"cocrystal structure of VVD-214 bound to WRN (PDB: 7GQU)"*
- Selection rationale is now chemotype-based (correct) rather than resolution-based (was incorrect).

Also updated the §7 summary-table row for 7GQU to acknowledge 10AK's higher resolution.

### 3.2 Correction 2 (was MINOR, now PASS) — Category H1

**Original claim (§1 State classification table):**

> *"Fragment-bound | 9 | 9MJU, 9MJV, 9MJW, 9MJX, 9MJY, 9MJZ, 9MK0, 9MK1 (+ 1 more)"*

**Audit finding:** The "+1 more" was undocumented. Verification identified the 9th fragment-bound PDB as **9RUS** (fragment ligand GQP = 1-[(4-fluorophenyl)methyl]benzimidazole, Vividion "AI-assisted delivery" 2026 paper).

**Correction applied:** Replaced "(+ 1 more)" with explicit "9RUS" in the state-classification table.

---

## 4. Claims That PASSED Without Correction (37)

### Category A — State classification counts (8/8 PASS)

- All 6 conformational classes have counts matching structure_inventory.csv exactly:
  - Covalent-ligand-bound (10): 10AK, 10AP, 7GQU, 9OG8, 9QBU, 9QBV, 9RTI, 9RUR, 9S17, 9S1B (all confirmed via `_struct_conn` LINK records with Cys727 SG–C covalent bond)
  - Non-covalent inhibitor-bound (10): 10AJ, 8PFL, 8PFO, 9OG3, 9OW9, 9OWA, 9OWB, 9OWC, 9OWD, 9S18
  - Fragment-bound (9): 9MJU, 9MJV, 9MJW, 9MJX, 9MJY, 9MJZ, 9MK0, 9MK1, **9RUS**
  - Nucleotide-bound (5): 6YHR, 7GQS, 7GQT, 8PFP, 9MJS
  - Apo (2): 9MJT, 9S1A
  - DNA-bound (1): 9S19
- Sum = 37 ✓

### Category B — Excluded structures (5/5 PASS)

- 10 classic exonuclease-domain (2AXL, 2DGZ, 2E1E, 2E1F, 2FBT, 2FBV, 2FBX, 2FBY, 2FC0, 3AAF) — verified excluded in Phase 2 transcript
- 7XUT — RCSB confirms "RPA70N-WRN fusion protein, 140 aa total"
- 6TYV — RCSB confirms "Ku80 vWA + 13-residue WRN Ku-binding motif peptide"
- 8YLE — residue range 9-428 (N-terminal / exonuclease domain), no resistance residues
- 9HZG — residue range 12-231 (WRN exonuclease domain), no resistance residues

### Category C — 9MJT apo template (5/5 PASS)

- Resolution 1.73 Å (all 3 sources agree)
- All 5 resistance residues present (L528, C727, G729, F730, I852) with correct identity
- Mutation-free (RCSB API confirms `rcsb_mutation_count=0`; mmCIF has no `struct_ref_seq_dif` engineered mutation)
- 9S1A alternative is missing L528 (residue range 529-939 excludes 528 region)

### Category D — 9S18 + 8PFO comparison (6/6 PASS)

- 9S18 resolution 1.995 Å (all 3 sources agree)
- 9S18 has YHC = HRO761 (RCSB CCD IUPAC name matches Novartis 2024 Nature compound)
- 9S18 is mutation-free (`rcsb_mutation_count=0` from RCSB polymer entity API)
- 8PFO resolution 1.9 Å (RCSB rounded; CSV+mmCIF=1.88 Å exact)
- 8PFO has 6 engineered mutations: E625A, R564A, R785A, R803A, E886A, R942A — all verified via mmCIF `_struct_ref_seq_dif` engineered mutation records AND RCSB `rcsb_mutation_count=6`

### Category E — 7GQU + 9OG8 comparison (5/6 first-pass PASS, 1 corrected → 6/6 PASS)

- 7GQU resolution 1.54 Å (all 3 sources agree)
- 7GQU has X1L = VVD-214 (confirmed via Kikuchi 2025 J Med Chem VVD-214 discovery paper itself citing 7GQU)
- 7GQU S–C = 1.82 Å (mmCIF `_struct_conn` LINK 1.82, 1.807 Å dual conformer)
- 9OG8 alternative: resolution 1.66 Å, ligand A1CA5 (compound 43 from DEL screen)
- 9OG8 S–C = **1.428 Å** — this is ~0.4 Å shorter than expected for a C–S single bond (typical 1.80–1.83 Å). All 3 sources agree on the anomalously short value; this is a real coordinate anomaly, not an audit error.
- E6 (highest-resolution-in-class claim) was corrected — see §3.1.
- E7–E11: covalent-class table entries for 9S1B (GSK-WRN3), 10AK/10AP (cyclic vinyl sulfones), 9S17 (Vividion), 9QBU/9QBV (GSK), 9RTI/9RUR (Vividion BMCL series) all cross-verified via RCSB entry titles + citations.

### Category F — 9S19 DNA-bound uniqueness (1/1 PASS)

- 9S19 is the only structure in the 37-corpus with a polynucleotide entity. Confirmed via:
  - structure_inventory.csv `has_polynucleotide=True` count = 1
  - mmCIF `_entity_poly.type = 'polydeoxyribonucleotide'` count = 1
  - Per-CIF scan: no other PDB has DNA or RNA polymer entity

### Category G — Non-chosen state rationale (2/2 PASS)

- Nucleotide-bound (5) — all 5 (6YHR, 7GQS, 7GQT, 8PFP, 9MJS) confirmed to bind only ADP/ATP/AGS/ANP with no drug-like ligand. Interpretation ("ATP-site not central to resistance") is stated as scientific judgment, not a fact requiring verification.
- Fragment-bound (9) — all 9 confirmed to bind low-MW screening fragments (A1BL0–A1BL8, GQP). Interpretation ("chemically unrelated to Phase 1 inhibitors") is stated as scientific judgment.

### Category H — Table presentation (1/1 PASS after correction)

- "+ 1 more" replaced with explicit 9RUS — see §3.2.

---

## 5. Cross-Check Results (X1–X5)

| Check | Question | Result |
|---|---|---|
| **X1** | Does the rationale correctly identify the highest-resolution structure in each class? | **FAIL → corrected.** In the covalent class, rationale originally claimed 7GQU (1.54 Å) is highest but 10AK (1.37 Å) is higher. Correction applied (§3.1). |
| **X2** | Does a strictly-better alternative exist on ALL criteria (resolution AND mutation-free AND ligand identity AND residue coverage)? | **PASS.** Every template has at least one criterion that outweighs a competitor. 9MJT is strictly better than 9S1A (better resolution AND more residues). 9S18 has 8PFO alternative with better resolution but 8PFO has 6 engineered mutations. 7GQU has 10AK alternative with better resolution but 10AK binds a different chemotype (compound 4, not VVD-214). 9S19 has no alternative. |
| **X3** | Do all 4 templates satisfy every stated selection criterion? | **PASS.** 9MJT: apo + all-5-residues + mutation-free. 9S18: YHC + all-5-residues + mutation-free. 7GQU: X1L + Cys727-covalent + no-anomaly + high-resolution. 9S19: polynucleotide + all-5-residues + mutation-free. Every criterion satisfied. |
| **X4** | Does the auth_seq_id numbering in the mmCIF match UniProt Q14191 canonical numbering (positions 528, 727, 729, 730, 852)? | **PASS.** All 4 templates confirmed: L528=L, C727=C, G729=G, F730=F, I852=I at the exact canonical positions in auth_seq_id (verified via residue_mapping_table.csv + `_atom_site` parse). |
| **X5** | Are ligand identities (X1L=VVD-214, YHC=HRO761) verified beyond structure_inventory naming? | **PASS.** X1L confirmed as VVD-214 via Kikuchi 2025 J Med Chem paper stating "cocrystal of VVD-214 bound to WRN (PDB: 7GQU)". YHC confirmed as HRO761 via RCSB CCD IUPAC name matching the Novartis 2024 Nature description; also verified that 8PFL is the closely-related YH8 analog (same paper). |

---

## 6. Alternative-Template Analysis (What Was Not Chosen and Why)

To document the "no strictly-better alternative" conclusion of X2:

| Class | Chosen | Best challenger | Challenger advantage | Chosen advantage | Verdict |
|---|---|---|---|---|---|
| Apo | 9MJT (1.73 Å) | 9S1A (1.956 Å) | none | Better resolution AND L528 present | 9MJT dominates |
| Non-cov HRO761 | 9S18 (1.995 Å) | 8PFO (1.88 Å) | 0.11 Å better resolution | Mutation-free (8PFO has 6 engineered surface mutations) | Trade-off correctly acknowledged |
| Covalent VVD-214 | 7GQU (1.54 Å) | 10AK (1.37 Å) | 0.17 Å better resolution | Binds VVD-214 (10AK binds compound 4) | Ligand identity trumps resolution for chemotype-specific question |
| DNA-bound | 9S19 (2.3 Å) | none | — | Only DNA-bound in corpus | No alternative |

---

## 7. Data Provenance

All values in this audit were extracted from:

- **CSVs:** `/workspace/WRN_MSI-H-RESEARCH/phase2_structure_ligand_collection/structure_inventory.csv` (37 rows), `residue_mapping_table.csv` (185 rows), `ligand_inventory.csv` (9 rows) — verified BIT_IDENTICAL to RCSB in Phase 2 integrity check (commit `a688328`).
- **mmCIFs:** `/workspace/WRN_MSI-H-RESEARCH/phase2_structure_ligand_collection/protein_structure_files/*.cif` (37 files) — verified AUTHENTIC_RCSB (8/8 header integrity checks passed).
- **RCSB REST API:** live fetches on 2026-07-11 for 15 entry-level, 8 polymer-entity, 9 chem_comp records (200 ms polite delay).
- **Kikuchi 2025 J Med Chem paper** (PMC12751020) via WebSearch — confirmed X1L = VVD-214.

Machine-readable ledger: `audit_claim_ledger.csv` (39 rows × 8 columns).

---

## 8. Conclusion

The wildtype template selection panel {9MJT, 9S18, 7GQU, 9S19} is **methodologically defensible and factually accurate** after two corrections were applied. Both corrections were substantive (one FAIL, one presentation issue) but neither invalidated the underlying selection decisions — only the wording used to justify them. The corrected rationale document now passes 39/39 claims across all 8 categories and all 5 cross-checks.

**Gate decision: GO for Phase 4** (pocket geometry analysis).

The 4 templates capture 4 biologically distinct WRN states that map to the 4 resistance-mechanism questions Phase 3 was designed to answer, using the highest-quality mutation-free structure available for each state (with the covalent class where ligand identity took precedence over resolution).
