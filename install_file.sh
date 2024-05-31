#!/bin/bash

# Loading python and ROCM modules
module load python/3.10.2 rocm/5.6.0

# Exporting TMP and cache folders so that they do not affect the filesystem /tmp
export TMP=/gpfs/alpine1/scratch/$USER/cache_dir
mkdir -pv $TMP
export TEMP=$TMP
export TMPDIR=$TMP
export TEMPDIR=$TMP
export PIP_CACHE_DIR=$TMP


# Setting up install directories and pythonpath:
export PIP_INSTALL_DIR=${PWD}
export PYTHONPATH=$PYTHONPATH:$PIP_INSTALL_DIR

# Installing packages based on requirement file
python -m pip install -r requirements.txt --target=$PIP_INSTALL_DIR
python -m pip install -r requirements_2.txt --target=$PIP_INSTALL_DIR

# Installing scikit-learn
python3 -m venv sklearn-env
source sklearn-env/bin/activate
pip3 install -U scikit-learn
