# Unofficial NVIDIA CUDA Dockerfile for LAMMPS

[official nvidia-lammps](https://catalog.ngc.nvidia.com/orgs/hpc/containers/lammps/tags "nvidia docker") 
images doees not support sm75 and sm89.  

## Build

```bash
% docker image build --build-arg SM_NUMBER=sm_89 -t lammps-docker:0.1 .
```

## Usage

```bash
% docker container run --gpus=all --rm -v $(pwd):/work lammps-docker:0.1 /app/lmp -sf gpu -pk gpu 1 -in in.melt
```
