#!/usr/bin/env bats
load 'test_helper.sh'

function setup {
  conda_dir="miniconda"
  splinter_env="splinter-conda"
  splinter_conda_package="${splinter_env}.tar.gz"
  miniconda_install_script="Miniconda3-latest-MacOSX-x86_64.sh"
}

function teardown {
  if [[ -f $splinter_conda_package ]]; then rm -rf "$splinter_conda_package"; fi
}

@test './make.sh is executable' {
  assert_file_executable './make.sh'
}

@test './make.sh (successful conda env packaging)' {
  run ./make.sh
  assert_dir_not_exist "$conda_dir"
  assert_dir_not_exist "$miniconda_install_script"
  assert_file_exist    "$splinter_conda_package"
}

@test 'Run twice (conda env package already exists)' {
  run ./make.sh
  run ./make.sh
  assert_output --partial 'already exists'
}
