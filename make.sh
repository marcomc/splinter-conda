#!/usr/bin/env bash

environment_file="environment.yml"
conda_dir="miniconda"
miniconda_install_script="Miniconda3-latest-MacOSX-x86_64.sh"
miniconda_install_script_url="https://repo.anaconda.com/miniconda/${miniconda_install_script}"
splinter_env="splinter-conda"

if [ ! -d "./${conda_dir}" ]; then
  echo "Installing Miniconda into "./${conda_dir}""
  # remove old version of the installer
  rm -f "${miniconda_install_script}" || exit 1
  # Download Installare
  wget "${miniconda_install_script_url}" || exit 1
  # Install Conda
  yes | bash "${miniconda_install_script}" -f -b -p "./${conda_dir}"  || exit 1
fi
# Set the environment (equivalent to a temporary activation)
_CONDA_ROOT="$(pwd)/${conda_dir}"
export _CONDA_ROOT="${_CONDA_ROOT}"
export PATH="${_CONDA_ROOT}/bin:$PATH"

# Activate conda base environment
# shellcheck disable=SC1091
# source "./${conda_dir}/bin/activate"

# Install Conda packager
# conda config --set pip_interop_enabled True
echo "Updating Conda..."
conda update -y -n base -c defaults conda  || exit 1
echo "Installing Conda-Pack..."
conda install -y conda-forge::conda-pack  || exit 1

# Create and activate Splinter specific environment
# conda create -y -n "${splinter_env}"
if conda env list | cut -d " " -f1 | grep "${splinter_env}"; then
echo "Removing the exisiting '${splinter_env}' environment..."
  conda env remove -y -n "${splinter_env}" || exit 1
fi

echo "Creating the '${splinter_env}' environment..."
conda env create -f "${environment_file}"  || exit 1
# rm exisiting package
if [ -f "${splinter_env}.tar.gz" ]; then
  echo "Removing old package '${splinter_env}.tar.gz'..."
  rm "${splinter_env}.tar.gz" 2>/dev/null  || exit 1
fi

# create splinter-conda.tar.gz package
echo "Packing '${splinter_env}' into '${splinter_env}.tar.gz'..."
conda pack -n "${splinter_env}"  || echo "Packing errored!!" && exit 1
