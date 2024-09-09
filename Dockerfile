FROM nvidia/cuda:12.4.1-devel-ubuntu22.04 AS build
RUN apt-get update ; apt-get install -y git build-essential
WORKDIR /app
RUN apt-get install -y cmake ffmpeg libjpeg-dev
RUN git clone https://github.com/lammps/lammps.git
RUN apt-get install -y voro++ libeigen3-dev zlib1g-dev libfftw3-3 libzstd-dev gfortran mpich libfftw3-dev voro++-dev libzstd-dev clang-13 clang-format
RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes --force-yes --no-install-recommends  libmkl-full-dev
RUN export HIP_PLATFORM=nvcc && \
    export CUDA_PATH=/usr/local/cuda
ARG SM_NUMBER=sm_75
RUN mkdir lammps/cmake/build && cd lammps/cmake/build && cmake -C ../presets/most.cmake -D PKG_GPU=on -D GPU_API=CUDA -D HIP_ARCH=${SM_NUMBER} .. && make -j 4

FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04
WORKDIR /work
RUN mkdir /app
COPY --from=build /app/lammps/cmake/build/lmp /app/lmp
RUN apt-get update && apt-get install -y libgomp1 libjpeg-dev ffmpeg voro++ libfftw3-dev mpich 
RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes --force-yes --no-install-recommends  libmkl-full-dev
