#!/usr/bin/env bash
# Phase 6 MD — Docker entrypoint
# Verifies environment then runs whatever command was passed

set -euo pipefail

echo "==========================================="
echo "Phase 6 MD environment (WRN MSI-H)"
echo "==========================================="

# --- Verify GROMACS ---
if command -v gmx &>/dev/null; then
    gmx --version | head -3
else
    echo "ERROR: gmx not found"
    exit 1
fi

# --- Verify GPU ---
if command -v nvidia-smi &>/dev/null; then
    echo "GPU:"
    nvidia-smi -L
    nvidia-smi --query-gpu=memory.total,memory.free --format=csv,noheader
else
    echo "WARN: no GPU detected — MD will run on CPU (slow)"
fi

# --- Verify ligand params tools ---
for tool in acpype antechamber obabel; do
    if command -v $tool &>/dev/null; then
        echo "$tool: OK"
    else
        echo "WARN: $tool missing"
    fi
done

echo "==========================================="

# Pass control to user command (or start bash)
exec "$@"
