# Exageostat-R Installation Guide

---
This is an installation guide for Exageostat-R (an R package for Exageostat) . This guide serves as an overview of the 
dependencies needed by the project, how to install them , and install Exageostat itself.

ExageostatR is supported and tested on MacOS and Linux.

## Dependencies

----
Exageostat-R depends on the following software:

- **GSL** (GNU Scientific Library): A numerical library that provides mathematical routines
- **NLOPT** : Non-Linear Optimization Library
- **hwloc** : Library for abstraction of hierarchical topology in modern architectures
- **StarPu** : Dynamic Runtime System for Task-based Programming on several architectures
- **HiCMA** : Low Rank Matrix Computation Library
- **Chameleon** : Dense Linear Algebra Library
- **Stars-H** :High Performance Low Rank Matrix Approximation Library

## Direct Installation

----
Exageostat-R can be downloaded directly as an R-package on MacOS or Linux using the following R commands
```r
install.packages("devtools")
library("devtools")
Sys.setenv(MKLROOT="/opt/intel/mkl")  #Path to Intel MKL installation if present
install_git(url="https://github.com/ecrc/exageostatR")
```

Further options can be added to the installation command to support CUDA or MPI
```r
install_git(url="https://github.com/ecrc/exageostatR", configure.args=C('--enable-cuda'))
#OR
install_git(url="https://github.com/ecrc/exageostatR", configure.args=C('--enable-mpi'))
```
Alternatively, specific releases can be installed directly from tar files
```r
install.packages(repos=NULL, "exageostatr_1.0.1.tar.gz")
```

Or from a cloned local repository
```r
install_local(path="/path/to/exageostatR")
```

## Linux Installation

---
For users wishing to install dependencies independently on a Linux platform, the following steps can be helpful

### CMake >= 3.2.3

```shell
$ wget https://cmake.org/files/v3.10/cmake-3.10.0-rc3.tar.gz
$ tar -zxvf cmake-3.10.0-rc3.tar.gz
$ cd cmake-3.10.0-rc3
$ ./configure
$ make -j && make -j install
```

### Intel MKL

Intel MKL can be installed through several package managers (APT/ YUM/ Zypper) according to your Linux distribution.
By following the steps in this link https://software.intel.com/en-us/mkl, MKL can be installed as part of an Intel Toolkit
or as an independent package.

To help the configuration script find the MKL installation on your system, set the MKLROOT environment variable on your
system
```shell
export MKLROOT=/opt/intel/mkl #or more generally /path/to/mkl/installation
```

### NLOPT >= 2.4.2

```shell
$ wget http://ab-initio.mit.edu/nlopt/nlopt-2.4.2.tar.gz
$ tar -zxvf nlopt-2.4.2.tar.gz
$ cd nlopt-2.4.2
$ ./configure --enable-shared --without-guile
$ make -j && make -j install
```

### GSL >= 2.4

```shell
$ wget https://ftp.gnu.org/gnu/gsl/gsl-2.4.tar.gz
$ tar -zxvf gsl-2.4.tar.gz
$ cd gsl-2.4
$ ./configure
$ make -j && make -j install
```


### hwloc >= 1.11.5

```shell
$ wget https://www.open-mpi.org/software/hwloc/v1.11/downloads/hwloc-1.11.5.tar.gz
$ tar -zxvf hwloc-1.11.5.tar.gz
$ cd hwloc-1.11.5
$./configure
$ make -j && make -j install
```

### StarPu >= 1.3.9

```shell
$ wget https://files.inria.fr/starpu/starpu-1.3.9/starpu-1.3.9.tar.gz
$ tar -zxvf starpu-1.3.9.tar.gz
$ cd starpu-1.3.9
$ ./configure --disable-cuda --disable-mpi --disable-opencl    # The --enable-cuda --enable-opencl are used instead for
                                                               # GPU systems. --enable-mpi is used if MPI is required    
$ make -j && make -j install
```

### ECRC Dependencies

Users will also need to install some of the software from ECRC's public git repositories
```shell
$ git clone https://github.com/ecrc/hicma h
$ cd h
$ git submodule update --init --recursive

$ git clone https://github.com/ecrc/exageostatR.git
$ cd exageostatR
$ git submodule update --init --recursive
```

#### Chameleon
```shell
$ export PREFIX=${MKLROOT}  #This can also be set to the installation paths of LAPACKE, CBLAS and BLAS Libraries
$ cd h # Directory of HiCMA
$ cd chameleon
$ git checkout 8595b23
$ git submodule update --init --recursive
$ mkdir -p build && cd build
$ LDFLAGS="-L$PREFIX/lib" cmake -DCMAKE_C_FLAGS=-fPIC -DCHAMELEON_USE_MPI=$MPIVALUE -DCMAKE_BUILD_TYPE="Release" \ 
  -DCMAKE_C_FLAGS_RELEASE="-O3 -Ofast -w" -DCHAMELEON_USE_CUDA=$CUDAVALUE -DCHAMELEON_ENABLE_EXAMPLE=OFF \ 
  `-DCHAMELEON_ENABLE_TESTING=OFF -DCHAMELEON_ENABLE_TIMING=OFF` \ 
  -DBUILD_SHARED_LIBS=OFF ..
$ make
$ make install
```

#### STARS-H
```shell
$ git clone https://github.com/ecrc/stars-h stars-h
$ cd stars-h
$ git checkout 687c2dc6df085655959439c38a40ccbe7cb57f82
$ git submodule update --init --recursive 
$ mkdir -p build && cd build
$ cmake -DCMAKE_C_FLAGS=-fPIC -DCMAKE_BUILD_TYPE="Release" -DCMAKE_C_FLAGS_RELEASE="-O3 -Ofast -w"  \ 
 -DOPENMP=OFF -DSTARPU=OFF  -DEXAMPLES=OFF -DTESTING=OFF -DMPI=$MPIVALUE ..
$ make
$ make install
```

#### HiCMA
```shell
$ cd h
$ git checkout c8287eed9ea9a803fc88ab067426ac6baacaa534
$ mkdir -p build && cd build
cmake -DHICMA_USE_MPI=$MPIVALUE -DCMAKE_BUILD_TYPE="Release" -DCMAKE_C_FLAGS_RELEASE="-O3 -Ofast -w" \ 
-DBUILD_SHARED_LIBS=ON -DHICMA_ENABLE_TESTING=OFF -DHICMA_ENABLE_TIMING=OFF ..
$ make 
$ make install
```

#### Exageostat
```shell
$ cd exageostatR
$ cmake -DCMAKE_BUILD_TYPE="Release" -DCMAKE_C_FLAGS_RELEASE="-O3 -Ofast -w" -DBUILD_SHARED_LIBS=ON \ 
-DEXAGEOSTAT_EXAMPLES=OFF -DEXAGEOSTAT_USE_MPI=$MPIVALUE -DEXAGEOSTAT_USE_HICMA=ON ./src
```

## MacOS installation

---

The same procedure can be followed for MacOS systems, while making sure to install the appropriate distribution of 
the Intel MKL library

## Installation Notes

---
The above procedures assume sudo/root access to the system. If that is not the case, the following additions need to be
made in order to add your local installation directory (installdir) which would install all the required packages in the
specified directory :
1. All CMake commands need to include -DCMAKE_INSTALL_PREFIX=/path/to/installdir
2. All configure commands need to include -prefix=/path/to/installdir
3. The installation paths for NLOPT,GSL,hwloc, StarPU, Chameleon, STARS-H,HiCMA need to be added to the PKG_CONFIG_PATH
   environment variable. 

## Verification

---
You can verify your installation by running any of the following examples

1) Synthetic generation of Geo-spatial data with MLE exact
computation,
```R
library("exageostat") #Load ExaGeoStat-R lib.
seed = 0 #Initial seed to generate XY locs.
theta1 = 1 #Initial variance.
theta2 = 0.1 #Initial range.
theta3 = 0.5 #Initial smoothness.
dmetric = 0 #0 --> Euclidean distance, 1--> great circle distance.
n = 1600 #n*n locations grid.
ncores = 2 #Number of underlying CPUs.
gpus = 0 #Number of underlying GPUs.
ts = 320 #Tile_size: changing it can improve the performance.
p_grid = 1 #More than 1 in the case of distributed systems.
q_grid = 1 #More than 1 in the case of distributed systems.
clb = vector(mode="double",length = 3) #Optimization lower bounds values.
cub = vector(mode="double",length = 3) #Optimization upper bounds values.
theta_out = vector(mode="double",length = 3) #Parameter vector output.
globalveclen = 3*n
vecs_out = vector(mode="double",length = globalveclen)#Z measurements of n locations.
clb = as.double(c("0.01", "0.01", "0.01")) #Optimization lower bounds.
cub = as.double(c("5.00", "5.00", "5.00")) #Optimization upper bounds.
vecs_out[1:globalveclen] = -1.99
theta_out[1:3] = -1.99
exageostat_initR(ncores, gpus, ts) #Initiate exageostat instance.
vecs_out = exageostat_egenzR(n, ncores, gpus, ts, p_grid, q_grid,
theta1, theta2, theta3, dmetric, seed, globalveclen) #Generate Z observation vector.
theta_out = exageostat_emleR(n, ncores, gpus, ts, p_grid, q_grid,
vecs_out[1:n], vecs_out[n+1:(2*n)],
vecs_out[(2*n+1):(3*n)], clb, cub, dmetric, 0.0001, 20) #Exact Estimation (MLE).
exageostat_finalizeR() #Finalize exageostat instance
```
========================================================================
2)  Synthetic generation of Geo-spatial data with MLE TLR
    computation
```R
library("exageostat") #Load ExaGeoStat-R lib.
seed = 0 #Initial seed to generate XY locs.
theta1 = 1 #Initial variance.
theta2 = 0.03 #Initial range.
theta3 = 0.5 #Initial smoothness.
dmetric = 0 #0 --> Euclidean distance, 1--> great circle distance.
n = 900 #n*n locations grid.
ncores = 4 #Number of underlying CPUs.
gpus = 0 #Number of underlying GPUs.
ts = 320 #Tile_size: changing it can improve the performance.
lts = 600 #TLR_Tile_size: changing it can improve the performance.
tlr_acc = 7 #approximation accuracy 10^-(acc).
tlr_maxrank = 450 #Max rank.
p_grid = 1 #More than 1 in the case of distributed systems.
q_grid = 1 #More than 1 in the case of distributed systems.
clb = vector(mode="double",length = 3) #Optimization lower bounds values.
cub = vector(mode="double",length = 3) #Optimization upper bounds values.
theta_out = vector(mode="double",length = 3) #Parameter vector output.
globalveclen = 3*n
vecs_out = vector(mode="double",length = globalveclen)#Z measurements of n locations.
clb = as.double(c("0.01", "0.01", "0.01")) #Optimization lower bounds.
cub = as.double(c("5.00", "5.00", "5.00")) #Optimization upper bounds.
vecs_out[1:globalveclen] = -1.99
theta_out[1:3] = -1.99
exageostat_initR(ncores, gpus, ts) #Initiate exageostat instance.
vecs_out = exageostat_egenzR(n, ncores, gpus, ts, p_grid, q_grid,
theta1, theta2, theta3, dmetric, seed, globalveclen) #Generate Z observation vector.
theta_out = exageostat_tlrmleR(n, ncores, gpus, lts, p_grid, q_grid,
vecs_out[1:n], vecs_out[n+1:(2*n)], vecs_out[(2*n+1):(3*n)],
clb, cub, tlr_acc, tlr_maxrank, dmetric, 0.0001, 20) #TLR Estimation (MLE).
exageostat_finalizeR() #Finalize exageostat instance.
```
========================================================================
3)  Synthetic generation of Geo-spatial data with MLE DST
    computation
```R
library("exageostat") #Load ExaGeoStat-R lib.
seed = 0 #Initial seed to generate XY locs.
theta1 = 1 #Initial variance.
theta2 = 0.1 #Initial range.
theta3 = 0.5 #Initial smoothness.
dmetric = 0 #0 --> Euclidean distance, 1--> great circle distance.
n = 1600 #n*n locations grid.
ncores = 2 #Number of underlying CPUs.
gpus = 0 #Number of underlying GPUs.
ts = 320 #Tile_size: changing it can improve the performance.
p_grid = 1 #More than 1 in the case of distributed systems.
q_grid = 1 #More than 1 in the case of distributed systems.
clb = vector(mode="double",length = 3) #Optimization lower bounds values.
cub = vector(mode="double",length = 3) #Optimization upper bounds values.
theta_out = vector(mode="double",length = 3) #Parameter vector output.
globalveclen = 3*n
vecs_out = vector(mode="double",length = globalveclen)#Z measurements of n locations.
clb = as.double(c("0.01", "0.01", "0.01")) #Optimization lower bounds.
cub = as.double(c("5.00", "5.00", "5.00")) #Optimization upper bounds.
vecs_out[1:globalveclen] = -1.99
theta_out[1:3] = -1.99
exageostat_initR(ncores, gpus, ts) #Initiate exageostat instance.
vecs_out = exageostat_egenzR(n, ncores, gpus, ts, p_grid, q_grid,
theta1, theta2, theta3, dmetric, seed, globalveclen) #Generate Z observation vector.
theta_out = exageostat_dstmleR(n, ncores, gpus, ts, p_grid, q_grid,
vecs_out[1:n], vecs_out[n+1:(2*n)],
vecs_out[(2*n+1):(3*n)], clb, cub, dmetric, 0.0001, 20) #DST Estimation (MLE).
exageostat_finalizeR() #Finalize exageostat instance
```

========================================================================
4) Synthetic generation of measurements based on given
   Geo-spatial data locations with MLE Exact computation
```r
library("exageostat") #Load ExaGeoStat-R lib.
seed = 0 #Initial seed to generate XY locs.
theta1 = 1 #Initial variance.
theta2 = 0.1 #Initial range.
theta3 = 0.5 #Initial smoothness.
dmetric = 0 #0 --> Euclidean distance, 1--> great circle distance.
n = 1600 #n*n locations grid.
ncores = 2 #Number of underlying CPUs.
gpus = 0 #Number of underlying GPUs.
ts = 320 #Tile_size: changing it can improve the performance.
p_grid = 1 #More than 1 in the case of distributed systems.
q_grid = 1 #More than 1 in the case of distributed systems.
clb = vector(mode="double",length = 3) #Optimization lower bounds values.
cub = vector(mode="double",length = 3) #Optimization upper bounds values.
theta_out = vector(mode="double",length = 3) #Parameter vector output.
globalveclen = 3*n
x = rnorm(n = globalveclen, mean = 39.74, sd = 25.09)
#X dimension vector of n locations.
y = rnorm(n = globalveclen, mean = 80.45, sd = 100.19)
#Y dimension vector of n locations.
vecs_out = vector(mode="double",length = globalveclen)#Z measurements of n locations.
clb = as.double(c("0.01", "0.01", "0.01")) #Optimization lower bounds.
cub = as.double(c("5.00", "5.00", "5.00")) #Optimization upper bounds.
vecs_out[1:globalveclen] = -1.99
theta_out[1:3] = -1.99
exageostat_initR(ncores, gpus, ts) #Initiate exageostat instance.
vecs_out = exageostat_egenz_glR(n, ncores, gpus, ts, p_grid, q_grid,
x, y, theta1, theta2, theta3,
dmetric, globalveclen) #Generate Z observation vector based on given locations.
theta_out = exageostat_emleR(n, ncores, gpus, ts, p_grid, q_grid,
vecs_out[1:n], vecs_out[n+1:(2*n)],
vecs_out[(2*n+1):(3*n)], clb, cub, dmetric, 0.0001, 20) #Exact Estimation (MLE).
exageostat_finalizeR() #Finalize exageostat instance
```

