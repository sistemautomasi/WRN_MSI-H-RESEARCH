# Phase 6 MD Protocol

Detailed methodology for the Methods section of the Phase 6 manuscript.

---

## 1. System preparation

### 1.1 Starting structures
Each MD system starts from the best Vina-docked pose of Phase 5, stored as a
combined receptor-ligand PDB in `../phase5_docking_analysis/complexes/`:
- `C727R_9S18_HRO761_complex.pdb` — 4164 protein atoms + 51 HRO761 heavy atoms
- `WT_9S18_HRO761_complex.pdb`    — 4368 + 51
- `C727A_9S18_HRO761_complex.pdb` — 4153 + 51

Docking was performed with AutoDock Vina 1.2.5, exhaustiveness=16, seed=42,
box 24 Å centred on the Phase 4 anchor of the 9S18 crystal structure (RCSB
9S18, Ferretti et al. 2024, DOI 10.1038/s41586-024-07350-y).

### 1.2 Protein topology
Protein prepared via `gmx pdb2gmx` with AMBER99SB-ILDN force field
(Lindorff-Larsen et al. 2010, doi:10.1002/prot.22711) and TIP3P water model.
All hydrogens rebuilt from FF definitions (`-ignh`); alternate conformers
(altloc B) stripped; missing atoms in terminal residues allowed (`-missing`).

### 1.3 Ligand topology (HRO761)
HRO761 canonical SMILES verified against PubChem CID 166140536:
```
CCC1=C(C(=O)N2C(=NC(=N2)C3=CCOCC3)N1CC(=O)NC4=C(C=C(C=C4)C(F)(F)F)Cl)N5CCN(CC5)C(=O)C6=NC=NC(=C6O)C
```
Molecular formula C31H31ClF3N9O5, MW 702.1 g/mol, 49 heavy atoms.

Ligand parameters generated via **acpype 2023.10.27** using antechamber with:
- Atom types: **GAFF2** (Wang et al. 2004; Wang et al. 2006)
- Charges: **AM1-BCC** (Jakalian et al. 2000, doi:10.1002/jcc.10128)
- Formal net charge: 0
- Hydrogens added by OpenBabel at pH 7.4

### 1.4 Solvation and ionisation
- Simulation box: cubic, 1.0 nm buffer from protein farthest atom (`gmx editconf -d 1.0`)
- Water: TIP3P via `gmx solvate` with `spc216.gro` template
- Ions: 0.15 M NaCl neutralised via `gmx genion` (default random seed logged)
- Final system: ~50k atoms typical

---

## 2. Energy minimisation
Steepest descent until Fmax < 500 kJ/mol/nm or 100,000 steps.

Parameters (`mdp/em.mdp`):
- integrator: steep, emstep 0.01 nm
- Neighbour searching: Verlet, cutoff-scheme, nstlist 10
- Electrostatics: PME, rcoulomb 1.2 nm, PME order 4, fourierspacing 0.16
- vdW: cutoff 1.2 nm with DispCorr EnerPres
- No constraints during EM

---

## 3. Equilibration (2-stage)

### 3.1 NVT (200 ps at 310 K)
Position restraints on protein heavy atoms + ligand heavy atoms
(`define = -DPOSRES` invokes `posre.itp` and `posre_LIG.itp`).
- dt = 2 fs with LINCS h-bonds (lincs_iter=1, lincs_order=4)
- Thermostat: V-rescale, two coupling groups (`Protein_LIG` and `Water_and_ions`)
- ref_t = 310 K, tau_t = 0.1 ps
- gen_vel = yes at 310 K, gen_seed = -1 (recorded)

### 3.2 NPT (500 ps at 310 K, 1 atm)
Continues from NVT with velocities carried over.
- Pressure coupling: C-rescale (isotropic), tau_p = 2.0 ps, ref_p = 1.0 bar
- Isothermal compressibility: 4.5e-5 bar⁻¹
- Position restraints still applied
- Output every 10 ps (compressed XTC)

Convergence criteria:
- Temperature: mean 310 ± 2 K over the last 100 ps
- Density: within 2% of TIP3P bulk (~1.00 g/cm³)
- Pressure: mean within 1 ± 0.5 atm

---

## 4. Production (100 ns per system)

Parameters (`mdp/prod.mdp`):
- integrator: md, dt = 2 fs, nsteps = 50,000,000
- **No position restraints**
- Thermostat: V-rescale (as equilibration)
- Barostat: **Parrinello-Rahman** (isotropic), tau_p = 2.0 ps
- Constraints: LINCS on h-bonds
- Output: XTC every 100 ps → 1000 frames per trajectory
- ld_seed = -1 (recorded in `prod.log`)

GPU offload flags:
```
gmx mdrun -deffnm prod \
    -nb gpu -pme gpu -update gpu -bonded gpu \
    -pin on -pinstride 1 -maxh 47
```

Checkpoints written every 15 min. Automatic resume via `-cpi prod.cpt -append`
if instance restart occurs (Vast.ai spot fallback).

---

## 5. Analysis pipeline

### 5.1 PBC-corrected trajectory
`gmx trjconv -pbc mol -center -ur compact` on `Protein` centring group, output
`prod_pbc.xtc` used for all subsequent analyses.

### 5.2 Standard trajectory metrics
| Analysis | GROMACS tool | Output | Sampling |
|---|---|---|---|
| Backbone RMSD | `gmx rms -select Backbone` | `rmsd_backbone.xvg` | all frames |
| Ligand heavy-atom RMSD | `gmx rms -select LIG` (fit on Backbone) | `rmsd_ligand.xvg` | all frames |
| Per-residue RMSF | `gmx rmsf -res -b 50000` | `rmsf_backbone.xvg` | last 50 ns |
| Radius of gyration | `gmx gyrate -select Protein` | `gyrate.xvg` | all frames |
| Ligand-protein H-bonds | `gmx hbond -select LIG -reference Protein` | `hbond_lig_prot.xvg` | all frames |
| Mut727-CA to ligand-COM distance | `gmx distance` on custom index | `dist_mut727_lig.xvg` | all frames |
| Contact residues (< 4.5 Å) | `gmx mindist -d 0.45 -on` | `contact_residues.ndx` | last 50 ns |

### 5.3 MM/PBSA binding free energy
Using **gmx_MMPBSA v1.6.4** (Valdés-Tresanco et al. 2021,
doi:10.1021/acs.jctc.1c00645) on 100 evenly-spaced frames from the 50-100 ns
window.

- GB model: OBC (igb=5), saltcon 0.150 M
- PB model: fillratio 4.0, istrng 0.150 M, radiopt 0
- Per-residue decomposition: `idecomp=1`, residues within 4.5 Å of ligand

Output: `mmpbsa_results.dat` (summary), `mmpbsa_energy.csv` (per-frame ΔG),
`mmpbsa_decomp.csv` (per-residue).

---

## 6. Acceptance criteria (per system)

Automated by `check_pipeline.sh`:
1. **Files present**: prod.gro, prod.xtc, prod.edr, prod.log
2. **Steps completed**: ≥ 49,000,000 of 50,000,000 (allows ≤ 2% early exit)
3. **Temperature**: mean 310 ± 2 K across trajectory
4. **LINCS warnings**: < 100 total (indicates no bad geometry)
5. **Ligand stability** (informational, not a hard pass/fail): final
   ligand-mut727 distance recorded

Failures halt the aggregate report and require investigation via
`troubleshooting.md`.

---

## 7. Publication figures

Generated by `08_make_figures.py`, all at 300 dpi with editable SVG (`svg.fonttype=none`).
- **Fig A**: Backbone RMSD × time (3 systems overlay)
- **Fig B**: Ligand RMSD × time (3 systems overlay)
- **Fig C**: Per-residue RMSF (highlight Cys/Arg/Ala 727, Gly729, Phe730)
- **Fig D**: H-bond count × time (10 ns rolling mean)
- **Fig E**: Res727 CA → ligand distance × time
- **Fig F**: Radius of gyration × time
- **Fig G**: MM/PBSA ΔG barplot ± SEM

Palette (Phylo): `#000000` WT, `#FF9400` C727R (top hit), `#75A025` C727A (neg ctrl).
Font family: Liberation Sans (metric-equivalent to Arial).

---

## 8. Reproducibility

All random seeds (gen_seed for NVT, ld_seed for production, genion seed) are
`-1` (auto) at run time and logged verbatim in the corresponding `.log` files.
For deterministic re-runs, extract the recorded seeds from `nvt.log` and
`prod.log` and hard-code them in a second copy of the mdp files.

The Docker image (`docker/Dockerfile`) pins the NVIDIA NGC GROMACS 2023.2 image (CUDA-enabled) and acpype 2023.10.27
exactly. Rebuilding from the Dockerfile is the recommended path for exact
reproduction.

---

## 9. Not included

- Replicate MD (single trajectory per system). To enable replicates, rerun
  `05_production.sh` after modifying `mdp/prod.mdp` `ld_seed` and moving prior
  outputs to `prod_seed1/`, etc.
- Covalent (Michael) adduct MD for VVD-214: requires manual bond patching for
  the Cys727-SG → ligand-C linkage, out of Phase 6 scope.
- Enhanced sampling (metadynamics, REMD): future Phase 7.
- Membrane-bound simulations, ssDNA substrate, ATP cofactor: out of scope
  (Phase 5 was apo-helicase-domain).
