# splinter-conda
Miniconda pre-packed for Splinter provisioning tool.

It includes **Python**, **Ansible**, Wheel and Passlib. See [environment.yml](./environment.yml) for details of the packed components and versions.

# Build splinter-conda package

The below instructions have been scripted in [make.sh](./make.sh) to automate the process of creating a packaged version of `splinter-conda`

    #!/usr/bin/env bash

    # Download Installare
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh

    # Install Conda
    yes | bash Miniconda3-latest-MacOSX-x86_64.sh -f -b -p ./miniconda

    # Set the environment (equivalent to the activation)
    export _CONDA_ROOT="$(pwd)/miniconda"
    export PATH="${_CONDA_ROOT}/bin:$PATH"

    # Or activate conda base environment
    source miniconda/bin/activate

    # Install Conda packager
    conda update -y -n base -c defaults conda
    conda install -y -c conda-forge conda-pack

    # Create and activate Splinter specific environment
    conda create -y -n splinter-conda
    conda activate splinter-conda

    # Installer required packages
    conda install -y -c conda-forge python ansible wheel passlib textinfo

    # export the list of required packages
    # so that we can rebuild it from an environment file
    conda env export > environment.yml

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

    # Add the conda dir to your your PATH
    export _CONDA_ROOT="$(pwd)/$ENVDIR"
    export PATH="${_CONDA_ROOT}/bin:$PATH"

    # or activate the environment
    source $ENVDIR/bin/activate

    # VERY IMPORTANT! Cleanup prefixes from in the active environment.
    conda-unpack

    # Fix issues with SSL Certificates
    CERT_PATH=$(python -m certifi)
    export SSL_CERT_FILE=${CERT_PATH}
    export REQUESTS_CA_BUNDLE=${CERT_PATH}
