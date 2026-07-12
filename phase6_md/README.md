# Phase 6 — Molecular Dynamics (MD) scaffold

**Status**: SCAFFOLD ONLY — no MD runs have been executed in the source sandbox.
This folder contains everything you need to run 3 systems × 100 ns MD on
Vast.ai (or any GPU cluster). Follow [`VAST_AI_DEPLOYMENT.md`](VAST_AI_DEPLOYMENT.md).

**Purpose**: Provide orthogonal dynamic validation of Phase 5's top Vina docking
signal (`C727R_9S18_HRO761`, ΔScore +6.21 kcal/mol) by explicit-solvent
molecular dynamics, per the Results-draft §7 remediation path.

---

## Quick start

```bash
# 1. On your workstation — build & push Docker image
cd docker/
docker build -t <YOUR_DOCKERHUB>/wrn-md:v1 .
docker push <YOUR_DOCKERHUB>/wrn-md:v1

# 2. Rent RTX 4090 on Vast.ai (~$0.35/hour), use above image, mount phase6_md/ to /data

# 3. Inside the container
cd /data
bash run/run_all.sh       # ~6.5 days for 3 systems sequential
```

Or on any machine with GROMACS + acpype + Python:
```bash
cd phase6_md/
make prep-all             # ~1 hour total for all 3 systems
make prod-all             # ~6 days on RTX 4090
make analyze-all          # ~30 min
```

---

## What Phase 6 tests

Three systems selected from Phase 5 verdicts (top-signal A/B/C hero-figure comparison):

| System | Role | Vina ΔScore | Composite verdict |
|---|---|---:|---|
| `C727R_9S18_HRO761` | **Top hit** (largest resistance signal) | **+6.21 kcal/mol** | resistance (3/3 criteria) |
| `WT_9S18_HRO761` | **Baseline** (HRO761 at design pocket) | 0 (reference) | reference-wt |
| `C727A_9S18_HRO761` | **Negative control** (same position, no clash) | −0.86 kcal/mol | neutral (0/3 criteria) |

**Scientific hypothesis**: The steric-blockade mechanism inferred from docking
should manifest in MD as:
1. **Backbone RMSD**: C727R > WT, C727A ≈ WT
2. **Ligand pocket occupancy**: C727R ligand escapes/relocates; WT/C727A remain bound
3. **Contact stability**: C727R loses the 13 canonical contacts across trajectory
4. **MM/PBSA ΔG**: C727R substantially less favourable than WT/C727A

If observed, this triangulates the Phase 5 finding at MD-level and closes the
"single scoring function" limitation noted in `RESULTS_SECTION_DRAFT.md § 8`.

---

## Method summary

- **Engine**: GROMACS 2023.2 (NVIDIA NGC image) with GPU offload (`-nb gpu -pme gpu -update gpu -bonded gpu`)
- **Force field**: AMBER99SB-ILDN (protein) + GAFF2 (ligand via acpype) + TIP3P water
- **Ions**: 0.15 M NaCl, neutralised
- **Timestep**: 2 fs with LINCS h-bonds
- **Temperature**: 310 K (V-rescale)
- **Pressure**: 1 atm (Parrinello-Rahman, production)
- **Electrostatics**: PME, rcoulomb=1.2 nm
- **Production**: 100 ns per system, coordinates every 100 ps → 1000 frames
- **Reproducibility**: seed logged; checkpoints every 15 min

Full protocol: [`PROTOCOL.md`](PROTOCOL.md).

---

## Folder layout

```
phase6_md/
├── README.md                          — this file
├── PROTOCOL.md                        — detailed MD methodology (for methods section)
├── VAST_AI_DEPLOYMENT.md              — step-by-step Vast.ai guide
├── troubleshooting.md                 — common GROMACS pitfalls + fixes
├── expected_outputs.md                — what files appear at each stage
├── Makefile                           — build target orchestration
│
├── inputs/                            — per-system input PDBs + SMILES
│   ├── C727R_9S18_HRO761/
│   │   ├── complex.pdb                — verbatim from Phase 5
│   │   ├── protein.pdb                — chain A only (4164 atoms)
│   │   ├── ligand.pdb                 — chain L LIG only (51 atoms)
│   │   ├── ligand.smi                 — HRO761 canonical SMILES
│   │   └── SYSTEM_INFO.md
│   ├── WT_9S18_HRO761/                — (4368 atoms + 51 atoms)
│   └── C727A_9S18_HRO761/             — (4153 atoms + 51 atoms)
│
├── mdp/                               — GROMACS parameter files
│   ├── ions.mdp
│   ├── em.mdp                         — steepest descent
│   ├── nvt.mdp                        — 200 ps NVT at 310 K + POSRES
│   ├── npt.mdp                        — 500 ps NPT equilibration + POSRES
│   ├── prod.mdp                       — 100 ns production, no restraints
│   └── mmpbsa.mdp
│
├── scripts/                           — Pipeline stage scripts
│   ├── 00_prep_ligand.py              — OpenBabel + acpype (GAFF2 + AM1-BCC)
│   ├── 01_prep_protein.sh             — pdb2gmx (AMBER99SB-ILDN + TIP3P)
│   ├── 02_build_system.sh             — merge topol, solvate, ionise
│   ├── 03_minimize.sh                 — EM
│   ├── 04_equilibrate.sh              — NVT + NPT
│   ├── 05_production.sh               — 100 ns GPU MD
│   ├── 06_analyze.sh                  — RMSD/RMSF/Rg/H-bond/distance/contact
│   ├── 07_mmpbsa.sh                   — gmx_MMPBSA ΔG binding
│   ├── 08_make_figures.py             — 7 publication figures
│   └── check_pipeline.sh              — sanity check (5 acceptance criteria)
│
├── run/                               — Wrapper runners for Vast.ai
│   ├── run_all.sh                     — full 3-system pipeline
│   ├── run_one_system.sh              — single system
│   └── run_analysis_only.sh           — post-hoc analyses only
│
├── docker/
│   ├── Dockerfile                     — gromacs:2024.3 + acpype + gmx_MMPBSA
│   └── entrypoint.sh                  — startup env checks
│
└── figures/                           — Populated after `make figures`
    └── (figA_rmsd_backbone.[png|svg|pdf] etc.)
```

---

## Chmod note

The S3-backed `/mnt/results/` filesystem does not preserve exec bits, so on
Vast.ai/local deployment, run once:
```bash
chmod +x scripts/*.sh scripts/*.py run/*.sh docker/entrypoint.sh
```

---

## Compute estimate

| Metric | Value |
|---|---|
| Atoms per system | ~50k (protein + water + ions) |
| Throughput on RTX 4090 | ~50 ns/day |
| Per-system wall time | ~2 days (100 ns) + 1 h prep + 30 min analysis |
| 3 systems sequential | ~6.5 days total |
| Vast.ai cost estimate | ~$55 USD @ $0.35/h × 156 h |
| Trajectory disk | ~5 GB/system (100 ns @ 100 ps sampling, XTC) |

---

## Deliverables (after production complete)

Each system produces:
- `prod.xtc` — trajectory (1000 frames)
- `prod.gro` — final structure
- `prod.edr` — energies
- `rmsd_backbone.xvg`, `rmsd_ligand.xvg`, `rmsf_backbone.xvg`, `gyrate.xvg`
- `hbond_lig_prot.xvg`, `dist_mut727_lig.xvg`, `contact_residues.ndx`
- `mmpbsa_results.dat`, `mmpbsa_energy.csv`, `mmpbsa_decomp.csv`
- `check.log` (pass/fail acceptance criteria)

Aggregate:
- `figures/figA_rmsd_backbone.png/svg/pdf` through `figG_mmpbsa.png/svg/pdf`
- `phase6_report.md`

---

## Cross-refs

- Upstream input files: `../phase5_docking_analysis/complexes/*.pdb`
- Phase 5 verdicts / cross-validation: `../phase5_docking_analysis/phase5_verdicts.csv`,
  `../phase5_docking_analysis/phase5_cross_validation.csv`
- Phase 5 results draft (limitations sec §8): `../phase5_docking_analysis/RESULTS_SECTION_DRAFT.md`
- Chai-1 attempt (also inconclusive, see § 5.1 in report): `../phase5_docking_analysis/chai1_orthogonal/`
