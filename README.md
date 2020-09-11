# splinter-conda
Miniconda pre-packed for Splinter provisioning tool

# Build splinter-conda package

    #!/usr/bin/env bash

    # Download Installare
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh

    # Install Conda
    yes | bash Miniconda3-latest-MacOSX-x86_64.sh -f -b -p ./miniconda

    # Set the environment (equivalent to a temporary activation)
    export _CONDA_ROOT="$(pwd)/miniconda"
    export PATH="${_CONDA_ROOT}/bin:$PATH"

    # Activate conda base environment
    source miniconda/bin/activate

    # Install Conda packager
    yes | conda update -n base -c defaults conda
    yes | conda install -c conda-forge conda-pack

    # Create and activate Splinter specific environment
    yes | conda create -n splinter-conda
    conda activate splinter-conda

    # Installer required packages
    yes | conda install -c conda-forge ansible wheel passlib

    # Deactivate Splinter specific environment
    conda deactivate

    # create splinter-conda.tar.gz package
    conda pack -n splinter-conda

Upload the generated package to the required location (this repository or another project)

# Install and use the splinter-conda packaged environment

Download the `splinter-conda.tar.gz` package the run:

    #!/usr/bin/env bash
    ENVDIR='conda'
    mkdir $ENVDIR
    tar -xzf splinter-conda.tar.gz -C $ENVDIR

    # add the conda dir to your your PATH
    export _CONDA_ROOT="$(pwd)/$ENVDIR"
    export PATH="${_CONDA_ROOT}/bin:$PATH"

    # or activate the environment
    . $ENVDIR/bin/activate

    # Fix issues with SSL Certificates
    CERT_PATH=$(python -m certifi)
    export SSL_CERT_FILE=${CERT_PATH}
    export REQUESTS_CA_BUNDLE=${CERT_PATH}
