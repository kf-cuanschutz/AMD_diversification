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

# Scikit learn ENV
#source sklearn-env/bin/activate
# Deactivate the virtual ENV
#deactivate

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
export PATH=$PATH:$PIP_INSTALL_DIR/bin

# We may now start installing horovod

export GXX_PATH=/scratch/alpine/.xsede.org/kfotso/software/anaconda/envs/gxx_horovod_amd
export LD_LIBRARY_PATH=$LIBRARY_PATH:$GXX_PATH/lib
export PATH=$PATH:$GXX_PATH/bin:$GXX_PATH/include

# 2) Loading the appropriate module dependencies for Horovod:
module load gcc openmpi cuda cmake

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

# Other Horovod related variables
export HSA_OVERRIDE_GFX_VERSION=9.0.8 
export CMAKE_HIP_ARCHITECTURES="gfx908" 
export CMAKE_HIP_PLATFORM="gfx908" 
export ROCM_VERSION=5.6.0 
export HOROVOD_RCCL_LINK=SHARED 
export __HIP_PLATFORM_AMD__=1 
export HOROVOD_CPU_OPERATIONS=MPI 
export PYTORCH_ROCM_ARCH="gfx908" 
export AMDGPU_TARGET="gfx908" 
export AMDGPU_TARGETS="gfx908" 
export GFX_ARCH="gfx908" 
export HAVE_GPU=1  
export HOROVOD_WITH_PYTORCH=1 
export HAVE_ROCM=1 
export Pytorch_ROCM=1 
export HOROVOD_GPU_ALLREDUCE=NCCL 
export HOROVOD_GPU=ROCM 
export HOROVOD_ROCM_HOME=$ROCM_PATH 
export HOROVOD_WITH_MPI=1 

#Exporting the install directory
export PATH=$PATH:$HOROVOD_CMAKE_INSTALL_PREFIX/bin


