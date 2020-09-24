[![Build Status](https://api.travis-ci.com/marcomc/splinter-conda.png)](https://www.travis-ci.com/github/marcomc/splinter-conda/builds)
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

# Unit testing

BATS scripts are contained in './tests'

    bats ./tests

## Setup

### install bats-core ('/usr/local/bin/bats')
brew install bats-core
### add submodules to a project
    git submodule add https://github.com/ztombol/bats-support tests/test_helper/bats-support
    git submodule add https://github.com/bats-core/bats-assert  tests/test_helper/bats-assert
    git submodule add https://github.com/bats-core/bats-file  tests/test_helper/bats-file
    git commit -m 'Add bats-support/assert/file libraries'

### Load a library from the 'test_helper' directory.
    # file: tests/test_helper.sh
    #   $1 - name of library to load
    load_lib() {
      local name="$1"
      load "test_helper/${name}/load"
    }

    # load a library with only its name, instead of having to type the entire installation path.

    load_lib bats-support
    load_lib bats-assert
    load_lib bats-file

### Reference: official BATS documentation

* [Shared documentation](https://github.com/ztombol/bats-docs)
* [bats-core](https://github.com/bats-core/bats-core)
* [bats-support](https://github.com/bats-core/bats-support)
* [bats-assert](https://github.com/bats-core/bats-assert)
* [bats-file](https://github.com/bats-core/bats-file)
