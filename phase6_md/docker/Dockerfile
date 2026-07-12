# Phase 6 MD — Docker image for Vast.ai deployment
# Base: NVIDIA NGC official GROMACS 2023.2 with full CUDA + multi-GPU support
# Adds: Python 3 + acpype (GAFF2 ligand params) + gmx_MMPBSA + analysis stack
#
# Build:
#   docker build -t phase6md:latest .
# Run (Vast.ai):
#   docker run --gpus all -v /workspace:/data phase6md:latest bash -c "cd /data && make prod-all"

FROM nvcr.io/hpc/gromacs:2023.2

LABEL maintainer="Phylo Biomni — WRN MSI-H Phase 6 MD"
LABEL description="NGC GROMACS 2023.2 + acpype + gmx_MMPBSA + Python analysis stack"

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    GMX_ENABLE_DIRECT_GPU_COMM=1

# --- OS dependencies (NGC image is Ubuntu 22.04) ---
# ambertools (antechamber, parmchk2, tleap) is required by acpype
# We install via conda-forge as apt package `ambertools` is only in older Ubuntu.
RUN apt-get update && apt-get install -y --no-install-recommends \
      python3 python3-pip python3-dev python3-venv \
      openbabel \
      git wget curl bzip2 \
      libnetcdf-dev libhdf5-dev \
      make \
    && rm -rf /var/lib/apt/lists/*

# --- Install Miniconda + AmberTools (from conda-forge) ---
RUN wget -qO /tmp/mc.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash /tmp/mc.sh -b -p /opt/conda \
    && rm /tmp/mc.sh \
    && /opt/conda/bin/conda install -y -c conda-forge ambertools=23 \
    && /opt/conda/bin/conda clean -afy
ENV PATH=/opt/conda/bin:$PATH

# --- Python packages ---
# gmx_MMPBSA 1.6.4 is the last version that supports GROMACS 2023
RUN pip3 install --no-cache-dir --upgrade \
      acpype==2023.10.27 \
      parmed \
      mdanalysis \
      pandas \
      numpy \
      scipy \
      matplotlib \
      seaborn \
      "gmx_MMPBSA==1.6.4"

# --- Working directory ---
WORKDIR /data

# Copy entrypoint script (optional environment checks)
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# --- Vast.ai convention: bash shell entrypoint ---
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["bash"]
