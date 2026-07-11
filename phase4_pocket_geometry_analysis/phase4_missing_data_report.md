# Phase 4: Missing Data & Limitations Report

**Purpose**: Enumerate what Phase 4 pipeline **cannot** detect, and identify data gaps that must be filled with future methods (MD, docking, alchemical FEP).

---

## 1. Sidechain rearrangement blindness (KRITIKAL)

### Apa yang kami tak boleh lihat
PDBFixer (Phase 3 tool) hanya melakukan **rotamer library swap** tanpa energy minimization atau relaxation. Ini menyebabkan:

| Metric | Nilai untuk 26/28 non-9S19 mutants | Sebab |
|--------|-----------------------------------|-------|
| Cα RMSD (WT vs mutant) | 0.000 Å | Backbone identical by construction |
| Non-mutation sidechain terminal shift | 0.000 Å (392/392 residues) | Sidechains verbatim copy |
| χ1 dihedral non-mutation | Unchanged | Rotamer states preserved |

### Yang Fowler 2026 boleh lihat (kami tak boleh)
- F730 CB shift 5.7 Å untuk G729D mutant (MOE local refinement)
- Ligand pose RMSD 6.1 Å untuk AC2 dalam G729D pocket
- New D729-T573 H-bond formation
- Sidechain reorganization di ~10 residues sekitar mutation

### Impact pada interpretation
- **False negative untuk F730L**: Fletcher 2026 lapor F730 sits downstream Gly729 hinge dan occupy hydrophobic pocket berbeza antara apo dan ligand-bound conformations; F730S 93% allele frequency untuk HRO761 resistance. Kami detect 0 clash + 0 volume Δ. Pipeline blind kepada hydrophobic contact loss.
- **Partial detection untuk G729D**: Kami dapat clash sterik (11 di 7GQU), tetapi tak dapat H-bond flip atau F730 shift.
- **Weak signal untuk L528S**: Kami detect 0 signal. Betul mengikut Ferretti 2024 Nature (HRO761) + Fletcher 2026 (Comm Biol), tetapi kami tidak dapat confirm mekanisme sebenar (rearrangement subtle atau polar interaction changes).

### Mitigasi
Untuk investigate mekanisme sebenar, phase seterusnya perlu:
- **Local minimization** (energy refinement 10-100 residue radius)
- **MD simulation** ~100-1000 ns (Fowler guna 900 ns)
- **Alchemical FEP** untuk quantify ΔΔG binding

---

## 2. Chemistry-based resistance mekanisme (C727A, C727S)

### Apa yang berlaku
C727A dan C727S menghapus/tukar thiol nucleophile → tidak boleh form covalent bond dengan VVD-214 vinylsulfone warhead. Ini adalah **loss of chemistry**, bukan loss of geometry.

### Data pipeline kami
- 7GQU_C727A: 0 clashes, -68% volume (dari ligand removal), 0 Å RMSD
- 7GQU_C727S: 0 clashes, +5% volume, 0 Å RMSD
- Kedua-dua di 9MJT/9S18 states: minimal signal
- 9S19: [low-drug state] noise

### Interpretation
Pipeline geometry-only kami tidak sensitif kepada:
- Nucleophilic character of sulfur vs oxygen vs methyl
- Ability to form thioether bond
- Warhead compatibility

### Mitigasi
Untuk detect chemistry ablation, perlu:
- **QM/MM calculation** untuk reactive barrier
- **Docking dengan covalent constraint** (RDKit/MOE covalent docking)
- **Wet-lab validation** (biochemical activity assay dengan mutants)

---

## 3. 9S19 rebuild artifacts dan drug pocket absence

### Rebuild artifacts (dari Phase 3)
9S19 mutant PDBs mempunyai **14 residues rebuild artifacts** (N-terminal 10 + mid-chain 4) yang berbeza antara WT run dan mutant run. Ini menyebabkan:
- WT-vs-mutant global Cα RMSD 2.29 Å (bukan mutation-induced)
- Sequence identity 96.6% berbanding original 9S19 PDB

### Verified impact pada Phase 4
- Semua 14 rebuild residues adalah **luar** pocket-lining set (positions 528, 573, 575, 577, 705, 707, 711, 727, 729, 730, 846, 849, 851, 852, 917)
- Pocket-local Cα RMSD = 0 Å (tak terjejas)
- Sidechain terminal shifts = 0 Å

### Drug pocket absence dalam DNA-bound state
- 9S19 WT: nearest-to-C727 pocket = 303 Å³, druggability 0.000
- Berbanding 9MJT/9S18/7GQU: 1207-1570 Å³, druggability 0.87-0.94
- Ini adalah **legitimate finding**, bukan bug — Fletcher 2026 juga menyebut on-DNA state adalah conformationally distinct

### Impact pada CV
9S19 dikecualikan dari signal-counting. Cross-validation berbasis 3 druggable states sahaja.

---

## 4. Kepekatan MD-dependent phenomena

### Apa yang tak kami detect
Static PDBFixer models tidak dapat menangkap:
- **Loop dynamics**: Regions dengan B-factor tinggi (Fletcher's "motion residues")
- **Allosteric propagation**: Perubahan mekanisme dari mutation site ke pocket via network H-bond
- **Water-mediated interactions**: Water bridges yang stabilkan binding
- **Entropic contributions**: Ligand deconformation upon binding
- **Kinetic effects**: kon / koff differences

### Contoh spesifik
- **G729D allosteric flip** (Fowler): Dari data static kami, clash dengan F730 memberi hint sterik. Tetapi transformation ke D729-T573 H-bond memerlukan relaxation. MD 900 ns Fowler bagi masa untuk H-bond form.
- **VVD-214 cooperativity dengan ATP** (Fletcher): Nucleotide-binding synergy tidak dapat diukur dari static drug-binding pocket.

### Mitigasi (untuk future phases)
- Adopsi GROMACS + AMBER14SB force field (Fowler's stack)
- ~200 ns MD untuk apo + inhibitor-bound states
- Enhanced sampling (metadynamics) untuk sidechain flip pathways

---

## 5. Docking absent (untuk verify pose shift)

### Apa yang hilang
Fowler 2026 lapor ligand pose RMSD 6.1 Å untuk G729D — kesan yang boleh diukur hanya melalui **re-docking mutant pocket**. Kami tidak lakukan docking.

### Mengapa
- MOE Dock adalah commercial licence (Fowler ada, kami tidak)
- AutoDock/Vina memerlukan cadangan ligand start pose + parameterization
- Alternative: Boltz-2 atau Chai-1 (Deep learning docking) — belum diintegrasikan ke pipeline

### Yang boleh dilakukan sebagai proxy
- **VdW clash** dengan ligand atoms sebagai stand-in untuk pose shift
- Kami tak lakukan ini kerana ligand dibuang pra-analysis untuk C727 mutations, dan retained untuk others (asymmetric baseline)

### Mitigasi
Phase 5 boleh:
1. Re-dock semua mutant pockets dengan Chai-1 atau AutoDock Vina
2. Compute pose RMSD vs WT
3. Bandingkan dengan Fowler's MOE benchmark

---

## 6. Statistical power dan replicates

### Apa yang kami tak buat
- **Single rotamer per mutant** (PDBFixer default): kami tak sample beberapa rotamer configurations
- **Single-run MD** would ideally be triplicates
- **No error bars** pada volume/druggability (fpocket bootstrap possible tapi belum dibuat)

### Impact
Kami tak boleh distinguish "real signal" dari "rotamer-selection artifact" untuk kes marginal (contoh I852F 3/3 clashes tetapi weak literature).

### Mitigasi
- Sample 5-10 rotamer configurations per mutation
- Report distribution of clash counts (median + IQR)
- Bootstrap fpocket runs dengan minor coordinate perturbations

---

## 7. Sistem lain yang mungkin miss

### Global conformation not perturbed
Kami hanya lihat **local pocket geometry**. Mutations mungkin menyebabkan:
- Domain rotation (D1-D2 hinge)
- Long-range structural changes
- Oligomeric state changes

Semua ini tidak dilihat dalam PDBFixer static + fpocket pipeline.

### Cross-talk antara mutations
Kami analyse setiap mutation **individually**. Kombinasi mutations (contoh C727A + G729D) mungkin sinergi atau antagonis. Tidak dianalisis.

### Species/isoform variants
Kami guna canonical UniProt Q14191 (WRN human). Isoform variants atau species-specific residues tidak dipertimbangkan.

---

## 8. Ringkasan: What Phase 4 CAN and CANNOT do

### CAN
✓ Detect gross volume changes dari sidechain identity swap
✓ Detect sterik clashes dari mutation atoms overlapping tetangga
✓ Rank mutations by geometric perturbation severity
✓ Identify universal vs state-specific mutations
✓ Cross-validate signal dengan literatur wet-lab

### CANNOT
✗ Detect sidechain rearrangement (F730 shift)
✗ Detect new H-bond formation (D729-T573)
✗ Detect chemistry ablation (Cys→Ala warhead loss)
✗ Detect π-stack loss (F730 aromatic contact)
✗ Detect allosteric propagation
✗ Detect ligand pose shifts (no docking)
✗ Quantify ΔΔG binding
✗ Detect MD-dependent dynamics

---

## 9. Rekomendasi untuk Phase 5+

**Priority 1**: MD simulation ~200 ns untuk mutants dengan literature strong signal (C727A/S, F730L). Guna GROMACS + AMBER14SB (Fowler stack).

**Priority 2**: Docking dengan Chai-1 atau AutoDock Vina untuk quantify pose shifts. Cross-validate dengan Fowler's 6.1 Å benchmark untuk G729D.

**Priority 3**: Alchemical FEP untuk ΔΔG binding. Fokus pada C727A/S (chemistry ablation) dan G729D (allosteric).

**Priority 4**: Wet-lab collaboration untuk validate I852F (over-called signal dalam pipeline kami).

---

**Report author**: Biomni (Phylo AI)
**Verification**: Semua batasan cross-checked dengan Phase 3/4 transcript, PDBFixer documentation, dan literature methodology (Fowler MOE + GROMACS, Fletcher X-ray).
