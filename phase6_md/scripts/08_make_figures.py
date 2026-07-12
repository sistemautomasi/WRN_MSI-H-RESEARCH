#!/usr/bin/env python3
"""
Phase 6 MD — Publication figure generator

Reads XVG outputs from 06_analyze.sh and MMPBSA outputs from 07_mmpbsa.sh
across all 3 systems, then produces 7 publication figures (matplotlib+seaborn).

Usage:
    # From phase6_md/ directory (parent of run/):
    python scripts/08_make_figures.py \
        --systems C727R_9S18_HRO761 WT_9S18_HRO761 C727A_9S18_HRO761 \
        --run-root run/ \
        --out-dir figures/

Palette: Phylo (#000000 WT, #FF9400 C727R top-hit, #75A025 C727A neg-ctrl)
"""
import argparse
import re
from pathlib import Path
import numpy as np
import pandas as pd
import matplotlib
matplotlib.rcParams["font.family"] = ["Liberation Sans", "Arimo", "DejaVu Sans"]
matplotlib.rcParams["svg.fonttype"] = "none"
matplotlib.rcParams["pdf.fonttype"] = 42
import matplotlib.pyplot as plt
import seaborn as sns

PALETTE = {
    "C727R_9S18_HRO761": "#FF9400",   # orange, top-hit
    "WT_9S18_HRO761":    "#000000",   # black, WT baseline
    "C727A_9S18_HRO761": "#75A025",   # green, neg-ctrl
}
LABEL = {
    "C727R_9S18_HRO761": "C727R (top hit)",
    "WT_9S18_HRO761":    "WT (baseline)",
    "C727A_9S18_HRO761": "C727A (neg. ctrl)",
}


def read_xvg(path):
    """Read a GROMACS .xvg file: skip @/# lines, return numpy array."""
    data = []
    for line in Path(path).read_text().splitlines():
        line = line.strip()
        if not line or line.startswith(("#", "@")):
            continue
        parts = line.split()
        try:
            data.append([float(x) for x in parts])
        except ValueError:
            continue
    return np.array(data)


def savefig(fig, out_dir, name):
    out_dir = Path(out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    for ext in ("png", "svg", "pdf"):
        p = out_dir / f"{name}.{ext}"
        fig.savefig(p, dpi=300, bbox_inches="tight")
        print(f"  wrote {p}")
    plt.close(fig)


def plot_rmsd_backbone(systems, run_root, out_dir):
    fig, ax = plt.subplots(figsize=(8, 4))
    for s in systems:
        p = Path(run_root) / s / "rmsd_backbone.xvg"
        if not p.exists():
            print(f"  [WARN] missing {p}")
            continue
        d = read_xvg(p)
        ax.plot(d[:, 0], d[:, 1] * 10, label=LABEL[s], color=PALETTE[s], lw=1.5)
    ax.set_xlabel("Time (ns)")
    ax.set_ylabel("Backbone RMSD (Å)")
    ax.set_title("Fig A — Protein backbone RMSD across 100 ns")
    ax.axhline(3.0, ls=":", color="grey", lw=0.8, label="3 Å reference")
    ax.legend(loc="best", frameon=False)
    ax.spines[["top", "right"]].set_visible(False)
    savefig(fig, out_dir, "figA_rmsd_backbone")


def plot_rmsd_ligand(systems, run_root, out_dir):
    fig, ax = plt.subplots(figsize=(8, 4))
    for s in systems:
        p = Path(run_root) / s / "rmsd_ligand.xvg"
        if not p.exists():
            continue
        d = read_xvg(p)
        ax.plot(d[:, 0], d[:, 1] * 10, label=LABEL[s], color=PALETTE[s], lw=1.5)
    ax.set_xlabel("Time (ns)")
    ax.set_ylabel("Ligand heavy-atom RMSD (Å)")
    ax.set_title("Fig B — HRO761 ligand RMSD (fit on protein backbone)")
    ax.axhline(2.0, ls=":", color="grey", lw=0.8, label="Crystallographic 2 Å threshold")
    ax.legend(loc="best", frameon=False)
    ax.spines[["top", "right"]].set_visible(False)
    savefig(fig, out_dir, "figB_rmsd_ligand")


def plot_rmsf(systems, run_root, out_dir):
    fig, ax = plt.subplots(figsize=(10, 4))
    for s in systems:
        p = Path(run_root) / s / "rmsf_backbone.xvg"
        if not p.exists():
            continue
        d = read_xvg(p)
        ax.plot(d[:, 0], d[:, 1] * 10, label=LABEL[s], color=PALETTE[s], lw=1.2)
    ax.set_xlabel("Residue")
    ax.set_ylabel("RMSF (Å) [last 50 ns]")
    ax.set_title("Fig C — Per-residue RMSF")
    # Highlight key residues
    for res, lab, ha in [(727, "Cys/Arg/Ala 727", "left"),
                          (729, "Gly729", "left"),
                          (730, "Phe730", "left")]:
        ax.axvline(res, ls="--", color="grey", lw=0.6, alpha=0.5)
        ax.annotate(lab, xy=(res, ax.get_ylim()[1] * 0.95), rotation=90,
                    fontsize=8, va="top", ha=ha, color="grey")
    ax.legend(loc="best", frameon=False)
    ax.spines[["top", "right"]].set_visible(False)
    savefig(fig, out_dir, "figC_rmsf")


def plot_hbonds(systems, run_root, out_dir):
    fig, ax = plt.subplots(figsize=(8, 4))
    for s in systems:
        p = Path(run_root) / s / "hbond_lig_prot.xvg"
        if not p.exists():
            continue
        d = read_xvg(p)
        # Smooth with rolling window (100 frames = 10 ns)
        n_hb = d[:, 1]
        smoothed = pd.Series(n_hb).rolling(100, min_periods=1).mean().values
        ax.plot(d[:, 0], smoothed, label=LABEL[s], color=PALETTE[s], lw=1.5)
    ax.set_xlabel("Time (ns)")
    ax.set_ylabel("H-bonds (10 ns rolling mean)")
    ax.set_title("Fig D — Ligand-protein H-bond stability")
    ax.legend(loc="best", frameon=False)
    ax.spines[["top", "right"]].set_visible(False)
    savefig(fig, out_dir, "figD_hbonds")


def plot_dist_mut727(systems, run_root, out_dir):
    fig, ax = plt.subplots(figsize=(8, 4))
    for s in systems:
        p = Path(run_root) / s / "dist_mut727_lig.xvg"
        if not p.exists():
            continue
        d = read_xvg(p)
        ax.plot(d[:, 0], d[:, 1] * 10, label=LABEL[s], color=PALETTE[s], lw=1.5)
    ax.set_xlabel("Time (ns)")
    ax.set_ylabel("Distance res727 CA → HRO761 (Å)")
    ax.set_title("Fig E — Cys/mut 727 to ligand distance")
    ax.axhline(6.0, ls=":", color="grey", lw=0.8, label="Direct-contact threshold (6 Å)")
    ax.legend(loc="best", frameon=False)
    ax.spines[["top", "right"]].set_visible(False)
    savefig(fig, out_dir, "figE_dist_mut727")


def plot_gyrate(systems, run_root, out_dir):
    fig, ax = plt.subplots(figsize=(8, 4))
    for s in systems:
        p = Path(run_root) / s / "gyrate.xvg"
        if not p.exists():
            continue
        d = read_xvg(p)
        ax.plot(d[:, 0], d[:, 1] * 10, label=LABEL[s], color=PALETTE[s], lw=1.5)
    ax.set_xlabel("Time (ns)")
    ax.set_ylabel("Rg (Å)")
    ax.set_title("Fig F — Protein radius of gyration")
    ax.legend(loc="best", frameon=False)
    ax.spines[["top", "right"]].set_visible(False)
    savefig(fig, out_dir, "figF_gyrate")


def plot_mmpbsa(systems, run_root, out_dir):
    """Bar plot of ΔG binding ± SEM (bootstrap 100 frames)."""
    fig, ax = plt.subplots(figsize=(6, 4))
    means, sems, labels, colors = [], [], [], []
    for s in systems:
        p = Path(run_root) / s / "mmpbsa_energy.csv"
        if not p.exists():
            print(f"  [WARN] missing MMPBSA output for {s}")
            continue
        df = pd.read_csv(p)
        # gmx_MMPBSA typically outputs a "TOTAL" or "DELTA_G_TOTAL" column
        col = None
        for c in ["DELTA_TOTAL", "ΔG_binding", "delta_total", "TOTAL"]:
            if c in df.columns:
                col = c
                break
        if col is None:
            print(f"  [WARN] no ΔG column in {p}; columns = {df.columns.tolist()}")
            continue
        vals = df[col].dropna().values
        means.append(vals.mean())
        sems.append(vals.std(ddof=1) / np.sqrt(len(vals)))
        labels.append(LABEL[s])
        colors.append(PALETTE[s])
    x = np.arange(len(labels))
    ax.bar(x, means, yerr=sems, color=colors, capsize=5)
    ax.set_xticks(x)
    ax.set_xticklabels(labels, rotation=15)
    ax.set_ylabel("MM-PBSA ΔG (kcal/mol)")
    ax.set_title("Fig G — MM/PBSA binding free energy (± SEM, 100 frames)")
    ax.spines[["top", "right"]].set_visible(False)
    savefig(fig, out_dir, "figG_mmpbsa")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--systems", nargs="+", required=True)
    ap.add_argument("--run-root", required=True,
                    help="Root folder containing <system>/ subfolders with XVG outputs")
    ap.add_argument("--out-dir", default="figures")
    args = ap.parse_args()

    sns.set_style("white")
    print("[08_make_figures] Generating publication figures ...")
    plot_rmsd_backbone(args.systems, args.run_root, args.out_dir)
    plot_rmsd_ligand(args.systems, args.run_root, args.out_dir)
    plot_rmsf(args.systems, args.run_root, args.out_dir)
    plot_hbonds(args.systems, args.run_root, args.out_dir)
    plot_dist_mut727(args.systems, args.run_root, args.out_dir)
    plot_gyrate(args.systems, args.run_root, args.out_dir)
    plot_mmpbsa(args.systems, args.run_root, args.out_dir)
    print("[08_make_figures] DONE")


if __name__ == "__main__":
    main()
