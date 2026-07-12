# Vast.ai deployment guide — Phase 6 MD

Step-by-step guide to run 3 systems × 100 ns MD on a rented Vast.ai GPU.

---

## 0. Prerequisites

- **Vast.ai account** with $60+ credit (est. cost $55 USD)
- **Docker Hub account** (or any registry) — to host your custom image
- **Local machine** with Docker installed (for image build)
- **SSH client** — Vast.ai instances give SSH access
- **~50 GB local disk** to receive trajectory downloads

---

## 1. Build & push Docker image (5 minutes)

On your local workstation:

```bash
cd phase6_md/docker/
docker build -t <YOUR_USERNAME>/wrn-md:v1 .
docker push <YOUR_USERNAME>/wrn-md:v1
```

The image adds acpype + gmx_MMPBSA + Python stack on top of the official
`nvcr.io/hpc/gromacs:2023.2` (NVIDIA NGC) base + ambertools + acpype + gmx_MMPBSA. Expected size ~5 GB.

Verify locally first:
```bash
docker run --rm --gpus all <YOUR_USERNAME>/wrn-md:v1 gmx --version | head -3
docker run --rm --gpus all <YOUR_USERNAME>/wrn-md:v1 acpype -h | head -5
```

---

## 2. Rent Vast.ai GPU (2 minutes)

### Recommended: **RTX 4090** (24 GB VRAM)
- Throughput: ~50 ns/day for 50k-atom systems
- Cost: ~$0.30–0.50/hour
- Instance filter on Vast.ai:
  ```
  GPU: RTX 4090
  RAM: ≥ 32 GB
  Disk: ≥ 100 GB
  CUDA: ≥ 12.0
  Reliability: > 99%
  ```

### Alternative: **RTX 4080** or **RTX 3090** (24 GB)
Similar VRAM, ~20% slower — acceptable if 4090 unavailable.
Add ~1 day to timeline.

### AVOID
- < 16 GB VRAM cards (mdrun may OOM on solvent)
- Spot instances without checkpoint plans (already handled by our `-cpi`)

### Instance config
- **Image**: `<YOUR_USERNAME>/wrn-md:v1`
- **On-start script**: (leave blank — we'll ssh in)
- **Ports to expose**: none (SSH only)
- **Disk**: 100 GB (trajectories will fit in ~30 GB)

---

## 3. Upload input files (~5 min)

Once instance is running:

```bash
# From your local workstation
INSTANCE_IP=<paste from Vast.ai>
INSTANCE_PORT=<paste SSH port>

# Sync entire phase6_md/ scaffold to instance
rsync -avz --progress -e "ssh -p $INSTANCE_PORT" \
    ./phase6_md/ \
    root@$INSTANCE_IP:/data/
```

Alternative: `git clone` your repo onto the instance (if this scaffold is committed):
```bash
ssh -p $INSTANCE_PORT root@$INSTANCE_IP
cd /
git clone https://github.com/sistemautomasi/WRN_MSI-H-RESEARCH.git
mv WRN_MSI-H-RESEARCH/phase6_md /data
```

---

## 4. Verify environment (30 sec)

Inside the container:
```bash
ssh -p $INSTANCE_PORT root@$INSTANCE_IP
cd /data
chmod +x scripts/*.sh scripts/*.py run/*.sh docker/entrypoint.sh
bash docker/entrypoint.sh true    # runs env checks and exits
```

Expected output:
```
GROMACS version:    2024.3
GPU:                NVIDIA GeForce RTX 4090, 24564 MiB
acpype: OK
antechamber: OK
obabel: OK
```

---

## 5. Run pipeline (~6.5 days)

### Option A: Full pipeline in one command
```bash
cd /data
nohup bash run/run_all.sh > run_all.log 2>&1 &
disown
```

This runs all 3 systems sequentially:
- `C727R_9S18_HRO761` prep + 100 ns + analyze — ~2.5 days
- `WT_9S18_HRO761` prep + 100 ns + analyze     — ~2.5 days
- `C727A_9S18_HRO761` prep + 100 ns + analyze  — ~2.5 days

**Monitor**:
```bash
tail -f run_all.log
tail -f inputs/C727R_9S18_HRO761/prod.log
```

### Option B: One system at a time (safer for debugging)
```bash
bash run/run_one_system.sh C727R_9S18_HRO761
bash run/run_one_system.sh WT_9S18_HRO761
bash run/run_one_system.sh C727A_9S18_HRO761
make figures
make report
```

### Option C: Resume interrupted run
GROMACS mdrun automatically checkpoints every 15 min. If the instance restarts
(e.g. spot preemption), just rerun the same command:
```bash
bash run/run_one_system.sh C727R_9S18_HRO761
# 05_production.sh detects prod.cpt and resumes with -cpi
```

---

## 6. Download results (~10-30 min depending on connection)

Trajectory files (~5 GB per system × 3 = ~15 GB) can be pulled selectively:

### Compact deliverables (recommended — figures + analyses only, ~50 MB)
```bash
# From local
rsync -avz --progress -e "ssh -p $INSTANCE_PORT" \
    --include="*.xvg" --include="*.csv" --include="*.log" \
    --include="figures/***" --include="*.md" \
    --exclude="*.xtc" --exclude="*.trr" --exclude="*.tpr" \
    root@$INSTANCE_IP:/data/ \
    ./phase6_results/
```

### Full download (trajectories included, ~15 GB)
```bash
rsync -avz --progress -e "ssh -p $INSTANCE_PORT" \
    root@$INSTANCE_IP:/data/inputs/ \
    ./phase6_results/inputs/
```

### Compress before downloading (if slow connection)
On instance:
```bash
cd /data/inputs
for s in C727R_9S18_HRO761 WT_9S18_HRO761 C727A_9S18_HRO761; do
    tar czf $s.tar.gz $s/prod.{xtc,gro,tpr,edr,log} $s/*.xvg $s/*.csv
done
```
Then rsync the `.tar.gz` files.

---

## 7. Cost accounting

Estimated cost breakdown (RTX 4090 @ $0.35/h):

| Phase | Duration | Cost |
|---|---|---|
| Prep 3 systems | 3 × 1 h | $1 |
| Production 3 × 100 ns | 3 × 48 h | $50 |
| Analysis + MMPBSA 3 systems | 3 × 30 min | $0.50 |
| Overhead + idle | 3 h | $1 |
| **Total** | ~156 h | **~$53** |

Budget an extra 20% for retries: **$60 USD total**.

Parallel 3-GPU option (2.5 days wall-clock but higher cost):
- Rent 3× RTX 4090 simultaneously: ~$150 USD
- Only worth it if deadline < 3 days

---

## 8. Post-run tasks

After downloading:
1. Verify `check.log` for each system shows all criteria PASSED
2. Inspect `figures/*.png` visually — do the 3 systems separate cleanly?
3. Read `phase6_report.md`
4. If interesting patterns emerge, extract representative frames for
   PyMOL/ChimeraX rendering:
   ```bash
   echo "0" | gmx trjconv -f prod.xtc -s prod.tpr -o snap.pdb -dump 50000  # 50 ns snapshot
   ```

---

## 9. Common Vast.ai gotchas

- **Instance disappears mid-run**: rare but happens with spot instances.
  Our scripts checkpoint every 15 min — just resume. Consider "on-demand"
  instead of "interruptible" if cost allows (~2× price).
- **GPU driver mismatch**: pick instances with **CUDA ≥ 12.0** to match our
  Docker image. If mismatch: `nvidia-smi` inside container will show
  "Failed to initialize NVML".
- **Disk fills up**: our XTC files are ~5 GB each; keep at least 30 GB free.
  If disk fills, `mdrun` will crash — clean up old checkpoints
  (`rm prod.cpt_prev`) if needed.
- **SSH times out**: Vast.ai instances go through a proxy; if SSH hangs,
  reconnect with `ssh -o ServerAliveInterval=60`.

Full pitfalls list: [`troubleshooting.md`](troubleshooting.md).
