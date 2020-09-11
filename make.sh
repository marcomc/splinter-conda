#!/usr/bin/env bash

# Download Installare
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh

# Install Conda
yes | bash Miniconda3-latest-MacOSX-x86_64.sh -f -b -p ./miniconda

# Set the environment (equivalent to a temporary activation)
_CONDA_ROOT="$(pwd)/miniconda"
export _CONDA_ROOT="${_CONDA_ROOT}"
export PATH="${_CONDA_ROOT}/bin:$PATH"

# Activate conda base environment
# shellcheck disable=SC1091

source miniconda/bin/activate

# Install Conda packager
yes | conda update -n base -c defaults conda
yes | conda install -c conda-forge conda-pack

# Create and activate Splinter specific environment
yes | conda create -n splinter-conda

# Qctivate splinter-conda environment
conda activate splinter-conda

# Installer required packages
yes | conda install -c conda-forge ansible wheel passlib

# Deactivate splinter-conda  environment
conda deactivate

# rm exisiting package
rm splinter-conda.tar.gz

# create splinter-conda.tar.gz package
conda pack -n splinter-conda
