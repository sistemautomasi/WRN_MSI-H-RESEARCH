# Phase 6 MD — Troubleshooting

Known issues + fixes for common GROMACS / acpype / Vast.ai pitfalls.

---

## Ligand parameterisation (acpype)

### AM1-BCC charge fitting fails on HRO761

**Symptom**: `antechamber` returns error `"Cannot compute charges"` or the
resulting `LIG.itp` has all zero charges.

**Cause**: HRO761 has 49 heavy atoms, near the practical AM1 limit. Some
tautomer variants confuse antechamber.

**Fix**:
1. Verify the input `ligand_H.mol2` has explicit hydrogens (check with `head`).
2. Retry with different bond-order guess: `-c bcc -a gaff2 -m 2` (multiplicity 2).
3. Fallback: manually assign charges via **RESP with Gaussian**:
   ```bash
   antechamber -i ligand_H.mol2 -fi mol2 -o ligand_gaussian.gjf -fo gcrt \
       -gv 1 -ge ligand.gesp -c bcc
   # Run Gaussian, then:
   antechamber -i ligand.gesp -fi gesp -o ligand_resp.mol2 -fo mol2 -c resp
   ```
4. Ultimate fallback: use **openff-toolkit** with Sage 2.0.0 force field
   instead of GAFF2 (requires editing `00_prep_ligand.py`).

### acpype hangs or produces empty output

**Cause**: usually broken/incomplete ambertools installation in Docker image.

**Fix**: verify inside container:
```bash
which antechamber tleap parmchk2 && antechamber -h | head -2
```
If any missing, rebuild Docker image with:
```
RUN apt-get install -y ambertools && \
    ln -sf /usr/bin/tleap /usr/local/bin/tleap
```

---

## GROMACS setup

### `gmx pdb2gmx` "residue not found"

**Symptom**: `Residue 'LIG' not found in residue topology database.`

**Cause**: attempting to run pdb2gmx on the combined complex.pdb (which
includes LIG). Only feed pdb2gmx the **protein-only** PDB.

**Fix**: `01_prep_protein.sh` already handles this by using `protein.pdb`
(chain A only, no HETATM).

### make_ndx group numbers wrong

**Symptom**: `03_minimize.sh` fails with `Cannot merge groups: number not found`.

**Cause**: `make_ndx` default group numbers change with system composition.
Our template assumes group 1 = Protein, 13 = LIG, 14+ = solvent/ions.

**Fix**: run `make_ndx` interactively first to see actual group numbers:
```bash
cd inputs/<SYSTEM>
gmx make_ndx -f ionised.gro -o index.ndx
# Type 'q' to just list groups
```
Then edit `03_minimize.sh` to match. Common alternatives:
- Small proteins: LIG may be group 12
- Large systems with cofactors: LIG may be group 14 or higher

### PME on GPU fails (mdrun error)

**Symptom**: `PME on GPU requires -pmefft cpu unless...`

**Cause**: some CUDA versions require explicit PME FFT placement.

**Fix**: change `05_production.sh` from `-pme gpu` to `-pme gpu -pmefft cpu`,
or drop PME GPU offload entirely (`-pme cpu`) — costs ~15% throughput.

### LINCS warnings during production (>100)

**Symptom**: `Step X: LINCS WARNING relative constraint deviation Y`.

**Cause**: bad starting geometry (Vina pose has atoms too close).

**Fix**:
1. Extend equilibration NVT to 500 ps and NPT to 1 ns.
2. If persist, reduce timestep to 1 fs (`dt = 0.001`) for first 1 ns of production.
3. If LIG-protein clash: manually inspect docked pose in PyMOL — may need to
   choose Vina's rank 2 or 3 pose instead of best-score pose.

---

## Production run

### Instance restarts before completion

**Symptom**: production dies at step X (< 50M).

**Fix**: our `05_production.sh` auto-resumes:
```bash
bash scripts/05_production.sh
# Detects prod.cpt and appends via -cpi prod.cpt -append
```
Just rerun the same command until `prod.gro` appears.

### mdrun uses CPU instead of GPU

**Symptom**: slow throughput (~5 ns/day instead of ~50 ns/day).

**Cause**: GPU flags not being picked up.

**Fix**: verify:
```bash
nvidia-smi                          # GPU detected?
gmx mdrun -h | grep -A2 "\-nb"      # accepts gpu flag?
env | grep -E "CUDA|GMX"            # env vars set?
```
Common env issue in Vast.ai: `CUDA_VISIBLE_DEVICES` may be set to "" —
unset or set to "0" (first GPU).

### Trajectory file is corrupt

**Symptom**: `gmx check -f prod.xtc` reports "corrupted"; analysis crashes.

**Cause**: instance crash during XTC write.

**Fix**: XTC files support truncation recovery:
```bash
gmx check -f prod.xtc          # find last good step
gmx trjcat -f prod.xtc -o prod_clean.xtc -settime  # rewrites truncated file
mv prod_clean.xtc prod.xtc
```

---

## Analysis

### gmx_MMPBSA MPI errors

**Symptom**: `mpirun encountered NULL communicator`.

**Cause**: gmx_MMPBSA needs MPI-enabled ambertools.

**Fix**: use non-MPI variant:
```bash
gmx_MMPBSA -O -i mmpbsa.in ...    # not gmx_MMPBSA MPI
```

### PB solver fails (fillratio too small)

**Symptom**: `Warning: PB solver did not converge` in `mmpbsa_results.dat`.

**Fix**: edit `mmpbsa.in`:
```
&pb
  fillratio  = 6.0     # was 4.0
  radiopt    = 1       # was 0 (use topology radii)
/
```

### Distance analysis: mut727 selection fails

**Symptom**: `gmx select` returns no atoms.

**Cause**: residue numbering after `pdb2gmx -renum` may shift Cys727 → e.g. resid 220.

**Fix**: verify with:
```bash
gmx select -s prod.tpr -select 'resname CYS or resname ARG or resname ALA'
```
Find the actual resid of the mutation site and edit `06_analyze.sh` line
```
-select 'resid 727 and name CA' ...
```
to the correct resid.

---

## Vast.ai-specific

### Docker image pull fails

**Symptom**: `docker: pull access denied` when instance starts.

**Fix**:
- If your image is private, add pull secret to Vast.ai:
  Instance → Config → Docker Auth → `<hub_user>:<token>`
- Public images always work.

### SSH connection drops during long runs

**Fix**: use `tmux` or `screen` inside the container:
```bash
apt-get install -y tmux
tmux new-session -s md
bash run/run_all.sh
# Detach: Ctrl-b, d
# Reattach later: tmux attach -t md
```

### Instance storage fills up

**Symptom**: mdrun crashes with `write failed: No space left on device`.

**Fix**:
1. Delete old checkpoints: `rm inputs/*/prod.cpt_prev`
2. Compress previous XTC: `gzip inputs/<system>/prod.xtc` (mdrun will rewrite)
3. Rent instance with more disk (100+ GB).

---

## When all else fails

1. Save all `.log` files and `prod.cpt` to persistent storage (Vast.ai has a
   "storage" flag on some instances).
2. Post issue in <https://gromacs.org/support>  with the full `prod.log`.
3. Escalate to Phase 7 (metadynamics or REMD) if the plain MD keeps failing —
   may indicate genuine biological instability rather than a technical bug.
