#!/usr/bin/env python3
"""
Phase 6 MD — Ligand parameterisation (GAFF2 via acpype)

Pipeline:
    ligand.pdb + ligand.smi
      -> OpenBabel: add hydrogens, assign 3D coords consistent with docked pose
      -> antechamber (via acpype): AM1-BCC charges + GAFF2 atom types
      -> Output: LIG.gro, LIG.itp, LIG_GMX.top, posre_LIG.itp

Usage:
    cd inputs/<SYSTEM>/
    python /data/scripts/00_prep_ligand.py --system C727R_9S18_HRO761

Outputs (in current working dir):
    LIG.acpype/LIG_GMX.gro
    LIG.acpype/LIG_GMX.itp
    LIG.acpype/LIG_GMX.top
    LIG.acpype/posre_LIG.itp
"""
import argparse
import subprocess
import sys
from pathlib import Path

def run(cmd, cwd=None, check=True):
    print(f"[00_prep_ligand] $ {' '.join(cmd)}", flush=True)
    r = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True)
    if r.stdout:
        print(r.stdout, flush=True)
    if r.stderr:
        print(r.stderr, file=sys.stderr, flush=True)
    if check and r.returncode != 0:
        raise SystemExit(f"[00_prep_ligand] Command failed with code {r.returncode}")
    return r


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--system", required=True, help="System name (must match folder)")
    ap.add_argument("--workdir", default=".", help="Working directory (default: cwd)")
    ap.add_argument("--net-charge", type=int, default=0,
                    help="Net formal charge of the ligand (HRO761 = 0)")
    ap.add_argument("--ligand-pdb", default="ligand.pdb")
    ap.add_argument("--ligand-smi", default="ligand.smi")
    args = ap.parse_args()

    wd = Path(args.workdir).resolve()
    lig_pdb = wd / args.ligand_pdb
    lig_smi = wd / args.ligand_smi
    if not lig_pdb.exists():
        sys.exit(f"Missing {lig_pdb}")

    # ---- Step 1: OpenBabel — add explicit hydrogens; keep 3D coords ----
    lig_h_pdb = wd / "ligand_H.pdb"
    run(["obabel", str(lig_pdb), "-O", str(lig_h_pdb), "-h", "--pH", "7.4"], cwd=wd)

    # ---- Step 2: Convert to mol2 (acpype prefers mol2 for antechamber) ----
    lig_mol2 = wd / "ligand_H.mol2"
    run(["obabel", str(lig_h_pdb), "-O", str(lig_mol2)], cwd=wd)

    # ---- Step 3: acpype (invokes antechamber + parmchk2 + tleap under hood) ----
    # -c bcc      = AM1-BCC charges
    # -a gaff2    = GAFF2 atom types
    # -n <charge> = formal net charge
    # -b LIG      = 3-letter residue name to force
    run(
        [
            "acpype",
            "-i", str(lig_mol2),
            "-b", "LIG",
            "-c", "bcc",
            "-a", "gaff2",
            "-n", str(args.net_charge),
            "-o", "gmx",
        ],
        cwd=wd,
    )

    # Rename output dir predictably: <input_stem>.acpype -> LIG.acpype
    default_out = wd / "ligand_H.acpype"
    predictable = wd / "LIG.acpype"
    if default_out.exists() and not predictable.exists():
        default_out.rename(predictable)

    # Sanity check outputs
    expected = ["LIG_GMX.gro", "LIG_GMX.itp", "LIG_GMX.top", "posre_LIG.itp"]
    missing = [f for f in expected if not (predictable / f).exists()]
    if missing:
        # Some acpype versions emit slightly different filenames; log and continue
        print(f"[00_prep_ligand] WARN: expected files missing: {missing}", file=sys.stderr)
        print(f"[00_prep_ligand]   contents: {list(predictable.iterdir())}", file=sys.stderr)

    # Emit clean symlinks that later scripts can rely on
    (wd / "LIG.gro").unlink(missing_ok=True)
    (wd / "LIG.itp").unlink(missing_ok=True)
    (wd / "posre_LIG.itp").unlink(missing_ok=True)
    (wd / "LIG.gro").symlink_to(predictable / "LIG_GMX.gro")
    (wd / "LIG.itp").symlink_to(predictable / "LIG_GMX.itp")
    if (predictable / "posre_LIG.itp").exists():
        (wd / "posre_LIG.itp").symlink_to(predictable / "posre_LIG.itp")

    print(f"[00_prep_ligand] SUCCESS — ligand params in {predictable}/", flush=True)


if __name__ == "__main__":
    main()
