#!/bin/bash

# We load ROCM which is the collection of drivers, libraries, tools and API to run 
# on an AMD GPU : https://rocm.docs.amd.com/en/latest/what-is-rocm.html
# For NVIDIA it is NVIDIA CUDA

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

# Deactivate the virtual ENV
deactivate

# We export all the ROCM related path and libraries
export ROCM_PATH=/curc/sw/install/rocm/5.6.0
export HIP_PATH=$ROCM_PATH
export HIP_ROOT_DIR=$ROCM_PATH
export ROCM_LIBRARIES=$ROCM_PATH/lib
export PYTHONPATH=$PIP_INSTALL_DIR:$PIP_INSTALL_DIR/bin:$PYTHONPATH
export PATH=$PIP_INTALL_DIR:$PATH
export DEVICE_LIB_PATH=/curc/sw/install/rocm/5.6.0/amdgcn/bitcode
export ROCM_DEVICE_LIB_PATH=/curc/sw/install/rocm/5.6.0/amdgcn/bitcode

# We need to specify the HIP platform
HIP_PLATFORM=amd
USE_ROCM=1
#pip install --target=$PIP_INSTALL_DIR cmake
pip install --target=$PIP_INSTALL_DIR  mxnet #mxnet is a deeplearning framework for efficiency and flexibility : https://pypi.org/project/mxnet/
export PATH=$PATH:$PIP_INSTALL_DIR/bin

# We may now start installing horovod

# 1) Installing GXX and exporting the path:
module load anaconda
conda create --name gxx_horovod_amd -c anaconda gxx_linux-64 -y

echo "************Activating environment*************"
conda activate gxx_horovod_amd

echo "************Environment activated **************"
conda install -c anaconda gxx_linux-64 -y
conda deactivate

echo "********** Environment deactivated *************"
module unload anaconda

export GXX_PATH=/scratch/alpine/.xsede.org/kfotso/software/anaconda/envs/gxx_horovod_amd
export LD_LIBRARY_PATH=$LIBRARY_PATH:$GXX_PATH/lib
export PATH=$PATH:$GXX_PATH/bin:$GXX_PATH/include

# 2) Loading the appropriate module dependencies for Horovod:
module load gcc openmpi cuda cmake

# 3) Exporting the appropriate NCCL related libraries:
#export HOROVOD_NCCL_INCLUDE=/projects/kefo9343/software/spack/opt/spack/linux-rhel8-zen/gcc-8.4.1/nccl-2.18.3-1-2pmuetqeeecftln5wn6jqy6xcvyzak6d/include
#export HOROVOD_NCCL_LIB=/projects/kefo9343/software/spack/opt/spack/linux-rhel8-zen/gcc-8.4.1/nccl-2.18.3-1-2pmuetqeeecftln5wn6jqy6xcvyzak6d/lib
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/projects/kefo9343/software/spack/opt/spack/linux-rhel8-zen/gcc-8.4.1/nccl-2.18.3-1-2pmuetqeeecftln5wn6jqy6xcvyzak6d/lib

export RCCL_INCLUDE_DIRS=/curc/sw/install/rocm/5.6.0/include:/curc/sw/install/rocm/5.6.0/rccl/include
export LD_LIBRARY_PATH=/curc/sw/install/rocm/5.6.0/lib:/curc/sw/install/rocm/5.6.0/rccl/lib:$LD_LIBRARY_PATH
export PATH=/curc/sw/install/rocm/5.6.0/rccl:/curc/sw/install/rocm/5.6.0/include:/curc/sw/install/rocm/5.6.0/rccl/include:$PATH

export HOROVOD_RCCL_INCLUDE=/curc/sw/install/rocm/5.6.0/include:/curc/sw/install/rocm/5.6.0/rccl/include
export HOROVOD_RCCL_LIB=/curc/sw/install/rocm/5.6.0/lib:/curc/sw/install/rocm/5.6.0/rccl/lib
export HOROVOD_RCCL_HOME=/curc/sw/install/rocm/5.6.0/rccl
# 4) Installing Horovod
export HOROVOD_INSTALL_DIR=$PIP_INSTALL_DIR          #/projects/$USER/software/horovod_amd_install
export HOROVOD_CMAKE_INSTALL_PREFIX=$HOROVOD_INSTALL_DIR/bin


echo "*************Installing Horovod ******************"
module list

export HSA_FORCE_FINE_GRAIN_PCIE=1 
export HSA_OVERRIDE_GFX_VERSION=9.0.8
export SDL_GFX_LIBRARIES=/curc/sw/install/rocm/5.6.0/lib/rocblas/library/Kernels.so-000-gfx908-xnack-.hsaco
#export SDL_GFX_LIBRARIES=$SDL_GFX_LIBRARIES:/curc/sw/install/rocm/5.6.0/rdc/lib/hsaco/gfx908/gpuReadWrite_kernels.hsaco:/curc/sw/install/rocm/5.6.0/rdc/lib/hsaco/gfx908/gpuReadWrite_kernels.hs
aco
export SDL_GFX_LIBRARIES=$SDL_GFX_LIBRARIES:/curc/sw/install/rocm/5.6.0/llvm/lib-debug/libomptarget-old-amdgpu-gfx908.bc
#export SDL_GFX_LIBRARIES=$SDL_GFX_LIBRARIES:/curc/sw/install/rocm/5.6.0/lib/rocblas/library/TensileLibrary_gfx908.co
export NVTX_INCLUDE_DIR=/curc/sw/cuda/12.1.1/include


HSA_OVERRIDE_GFX_VERSION=9.0.8 CMAKE_HIP_ARCHITECTURES="gfx908"  CMAKE_HIP_PLATFORM="gfx908" ROCM_VERSION=5.6.0 HOROVOD_RCCL_LINK=SHARED \
__HIP_PLATFORM_AMD__=1  HOROVOD_CPU_OPERATIONS=MPI PYTORCH_ROCM_ARCH="gfx908" \
AMDGPU_TARGET="gfx908" \
AMDGPU_TARGETS="gfx908" GFX_ARCH="gfx908" HAVE_GPU=1  HOROVOD_WITH_PYTORCH=1 HAVE_ROCM=1 Pytorch_ROCM=1 \
HOROVOD_GPU_ALLREDUCE=NCCL  HOROVOD_GPU=ROCM HOROVOD_ROCM_HOME=$ROCM_PATH HOROVOD_WITH_MPI=1 \
pip install --no-cache-dir  --target=$PIP_INSTALL_DIR   -v git+https://github.com/thomas-bouvier/horovod.git@compile-cpp17 --upgrade >& make_horovod_update_V20_.log &

# Very helpful link from here: https://github.com/horovod/horovod/issues/4014

#Exporting the install directory
export PATH=$PATH:$HOROVOD_CMAKE_INSTALL_PREFIX/bin

# 5) Finally checking the build:
echo "*************Checking Horovod build ******************"
horovodrun --check-build



