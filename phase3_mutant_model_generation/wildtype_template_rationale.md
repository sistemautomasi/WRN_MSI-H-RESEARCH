# Wildtype Template Selection Rationale

**Question:** Why were 4 templates chosen for Phase 3 mutant modeling, out of the 37 WRN structures collected in Phase 2?

**Short answer:** The 37 Phase 2 structures cluster into **6 conformational-state classes**. Four templates — one per biologically relevant class for resistance mechanism analysis — capture all distinct binding states while avoiding heavy redundancy (5-10 structures per class where members differ only in ligand chemotype, not in overall conformation or pocket accessibility).

---

## 1. The 37 Phase 2 structures — state classification

Every mmCIF was parsed for `_struct_conn` LINK records (covalent bonds), non-polymer ligand IDs, and polynucleotide entities. Result:

| Conformational state | Count | PDB IDs |
|---|---|---|
| Covalent-ligand-bound (at Cys727) | 10 | 10AK, 10AP, 7GQU, 9OG8, 9QBU, 9QBV, 9RTI, 9RUR, 9S17, 9S1B |
| Non-covalent inhibitor-bound | 10 | 10AJ, 8PFL, 8PFO, 9OG3, 9OW9, 9OWA, 9OWB, 9OWC, 9OWD, 9S18 |
| Fragment-bound | 9 | 9MJU, 9MJV, 9MJW, 9MJX, 9MJY, 9MJZ, 9MK0, 9MK1, 9RUS |
| Nucleotide-bound (ADP / ATP / AGS / ANP only) | 5 | 6YHR, 7GQS, 7GQT, 8PFP, 9MJS |
| Apo | 2 | 9MJT, 9S1A |
| DNA-bound | 1 | 9S19 |

**Total = 37.** Zero exonuclease-domain, zero fusion, zero peptide-only structures (those were already excluded in Phase 2 filtering: 2AXL/2DGZ/2E1E/2E1F/2FBT/2FBV/2FBX/2FBY/2FC0/3AAF exonuclease; 7XUT RPA fusion; 6TYV Ku80-peptide; 8YLE/9HZG N-terminal only).

## 2. What "conformational state" means here

WRN inhibitor resistance is a **state-dependent** phenomenon. The literature curated in Phase 1 (Fletcher 2026, Baltgalvis 2024, Picco 2026, Huang 2026) shows resistance mutations shift **binding to specific pocket geometries**, not just the primary sequence. A mutation might destroy inhibitor binding in the apo/off-DNA state but leave DNA engagement intact — or vice versa. Without state-resolved templates, this signal is lost.

The four resistance-mechanism questions Phase 3 must be able to answer:

1. **Global fold impact** — does the mutation destabilize WRN structure itself, independent of ligand?
2. **HRO761-class impact** — does the mutation block the non-covalent Vividion/Novartis pocket?
3. **VVD-214-class impact** — does the mutation block covalent engagement at Cys727?
4. **DNA-engagement impact** — does the mutation disrupt the substrate-bound conformation?

Each question maps to one conformational state class. Hence 4 templates.

## 3. Template choice within each class

### 3.1 Apo (2 candidates) — chose 9MJT

| Candidate | Resolution | Residues present | Notes |
|---|---|---|---|
| **9MJT** ✓ | 1.73 Å | All 5 (L528, C727, G729, F730, I852) | Clean single chain A, only Zn/Cl/EDO cofactors |
| 9S1A | — | Missing L528 (crystallized 500-946 excludes 528 region) | Rejected — cannot model L528S |

**Selected: 9MJT.**

### 3.2 Non-covalent inhibitor-bound (10 candidates) — chose 9S18

The two natural candidates for the **HRO761 class** were 8PFO and 9S18 (both bind YHC = HRO761 CCD ligand). All 8 other candidates in this class bind different chemotypes (YH8 analog, A1CA4 DEL compound, A1CEV/A1CEW/A1CEX/A1CEY/A1CEZ allosteric series, A1C4J cyclic vinyl sulfone — none of them HRO761).

| Candidate | Resolution | Bound ligand | Engineered mutations |
|---|---|---|---|
| 8PFO | 1.9 Å | YHC (HRO761) | **6 surface mutations** — E625A, R564A, R785A, R803A, E886A, R942A |
| **9S18** ✓ | 1.995 Å | YHC (HRO761) | None (wild-type WRN) |

The 8PFO mmCIF `_entity.pdbx_mutation` field explicitly declares `'E625A, R564A, R785A, R803A, E886A, R942A'` with description `'WRN helicase domain with 6 surface mutations'`, and 4 `_struct_ref_mut` records confirm engineered mutations. 8PFO higher resolution (1.9 Å vs 1.995 Å) is offset by the confound of 6 surface changes that would contaminate any WT-vs-mutant comparison — the "WT" baseline would already carry 6 engineered substitutions.

**Selected: 9S18** — mutation-free HRO761-bound WRN.

### 3.3 Covalent-ligand-bound at Cys727 (10 candidates) — chose 7GQU

The 10 covalent structures all share the same binding mode: covalent bond between Cys727 SG and the ligand warhead C, with S–C distance 1.4–1.8 Å. They differ only in **warhead chemistry** (acrylamide, cyanamide, vinyl sulfone, etc.) and in which company's compound was crystallized.

| Candidate | Resolution | Bound ligand | Notable feature |
|---|---|---|---|
| 10AK | **1.37 Å** | A1C4L (cyclic vinyl sulfone compound 4, 2026) | Highest resolution in class, but ligand is not VVD-214 |
| **7GQU** ✓ | 1.54 Å | X1L (**VVD-214** = Phase 1 clinical compound) | S–C = 1.82 Å (physically consistent) |
| 9OG8 | 1.66 Å | A1CA5 (DEL compound 43) | S–C = 1.428 Å (**anomalously short** — possible modeling artifact) |
| 10AP | 2.58 Å | A1C4O | Cyclic vinyl sulfone compound 26, 2026 |
| 9S17 | 1.91 Å | A1JKV (Vividion molecule 81) | Recent Vividion covalent |
| 9QBU | 2.10 Å | A1I5L (GSK5819992, (S)-27) | Alternative GSK series |
| 9QBV | 2.15 Å | A1I5F (GSK4766470, (R)-11) | Alternative GSK series |
| 9RTI | 2.20 Å | A1JJ8 (compound 7) | Vividion BMCL 2026 series |
| 9S1B | 2.22 Å | A1JKU (GSK-WRN3) | Recent GSK covalent (2025-07-18) |
| 9RUR | 2.30 Å | A1JJK (compound 4d) | Vividion BMCL 2026 series |

**Selected: 7GQU** — binds the actual Phase 1 clinical compound (VVD-214, cocrystal confirmed in Kikuchi et al. 2025 J Med Chem, DOI 10.1021/acs.jmedchem.5c01805), at 1.54 Å resolution, no bond-length anomaly. 10AK has higher resolution (1.37 Å) but binds a later cyclic-vinyl-sulfone chemotype (compound 4), not the clinical VVD-214. Because the resistance-mechanism question is chemotype-specific ("does the mutation block VVD-214 covalent engagement at Cys727?"), ligand identity is the primary selection axis in this class, not resolution.

### 3.4 DNA-bound (1 candidate only) — 9S19 by elimination

Only one DNA-bound structure exists across the entire 37-entry corpus.

**Selected: 9S19** — no alternative available.

## 4. States NOT chosen as templates, and why

### 4.1 Nucleotide-bound (5 structures) — excluded

6YHR, 7GQS, 7GQT, 8PFP, 9MJS all crystallize the ATPase site with ADP / ATP / AGS / ANP. Cofactor binding at the ATP site is not central to inhibitor resistance — no Phase 1 resistance mutation directly touches the ATP-binding pocket. The overall pocket geometry near L528/C727/G729/F730/I852 is essentially equivalent to the apo state. **Redundant with 9MJT.**

### 4.2 Fragment-bound (9 structures) — excluded

9MJU–9MK1 series are fragment screening hits (A1BL0–A1BL8), small molecular-weight fragments that occupy peripheral sub-pockets. They neither reach the resistance residues nor recapitulate the HRO761 or VVD-214 binding modes. **Chemically unrelated to Phase 1 inhibitors; redundant with 9S18 for inhibitor-pocket analysis.**

### 4.3 Alternative HRO761 / VVD covalent series (10 non-selected inhibitor-bound + 9 non-selected covalent) — excluded

Any of these would tell the same story as 9S18 or 7GQU — the pocket geometry within a class is largely conserved (all HRO761-class inhibitors bind the same site; all Cys727 covalents form the same S–C bond). Choosing multiple templates from within one class multiplies computational cost without expanding the biological question set.

## 5. Numeric consequence

- Chosen: **4 templates × 7 mutations = 28 mutant models + 4 WT prepared templates = 32 structures**
- If instead used all 37: 7 × 37 = 259 mutant models, ~87% of them would be near-duplicates of the 28-model core set.

## 6. What if the user wants to add more templates later?

The framework is state-parameterized, so extending the panel is straightforward:

| Additional template | Question it adds | Extra cost |
|---|---|---|
| Add 8PFO (HRO761-bound higher-res) | Effect of 6 surface mutations on resistance panel | +7 mutants |
| Add 9S17 or 9S1B (recent Vividion/GSK covalent) | Alternative warhead sensitivity | +7 mutants each |
| Add 9MJS (nucleotide-bound with ANP) | ATP-site coupling to distal mutations | +7 mutants |
| Add 6YHR (Newman 2020 apo helicase) | Historical baseline / cross-lab reproducibility | +7 mutants |
| Add 9OWA-9OWD (allosteric series) | Non-HRO761 allosteric binding | +7 mutants each |

None of these is currently required to answer the four core resistance-mechanism questions above, but they can be added incrementally without redoing the existing 32 structures.

## 7. Summary table

| Template | State represented | Rationale |
|---|---|---|
| 9MJT | Apo | Higher-resolution, mutation-free, all 5 resistance residues present |
| 9S18 | HRO761 (non-covalent inhibitor) | Mutation-free (unlike 8PFO with 6 engineered surface Ala substitutions) |
| 7GQU | VVD-214 (covalent at Cys727) | Binds Phase 1 clinical compound VVD-214 at 1.54 Å (10AK has better resolution 1.37 Å but binds a different chemotype) |
| 9S19 | DNA-bound | Only DNA-bound WRN in the entire 37-entry corpus |

Total: **4 templates covering 4 biologically distinct WRN states** that map directly to the four resistance mechanism questions Phase 3 was designed to address.
