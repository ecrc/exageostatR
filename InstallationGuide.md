# ExaGeoStatR Installation Guide

---
This is an installation guide for ExaGeoStatR (an R package for ExaGeoStat software). This guide serves as an overview of the 
software dependencies the project requires, how to install them, and how to eventually install ExaGeoStat itself.

ExaGeoStatR is supported and tested on MacOS and Linux OS.

## Software Dependencies

----
ExaGeoStatR depends on the following software libraries:

- **GSL** (GNU Scientific Library): A numerical library that provides mathematical routines
- **NLOPT** : Non-Linear optimization library
- **hwloc** : Library for abstraction of hierarchical topology in modern architectures
- **StarPU** : Dynamic runtime system for task-based programming models on several architectures
- **HiCMA** : Hierarchical computations on manycore architectures library
- **Chameleon** : A dense linear algebra software for heterogeneous architectures
- **Stars-H** : Testing accuracy, reliability and scalability of hierarchical computations software

## Direct Installation

----
ExaGeoStatR can be downloaded directly as an R-package on MacOS or Linux using the following R commands
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

Or from a local cloned repository
```r
install_local(path="/path/to/exageostatR")
```

## Linux Installation

---
For users wishing to install the software dependencies on their own on a Linux platform, the following steps can be helpful:

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

### StarPU >= 1.3.9

```shell
$ wget https://files.inria.fr/starpu/starpu-1.3.9/starpu-1.3.9.tar.gz
$ tar -zxvf starpu-1.3.9.tar.gz
$ cd starpu-1.3.9
$ ./configure --disable-cuda --disable-mpi --disable-opencl    # The --enable-cuda --enable-opencl are used instead for
                                                               # GPU systems. --enable-mpi is used if MPI is required    
$ make -j && make -j install
```

### ECRC Dependencies

Users will also need to install software from the ECRC's public git repositories
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

#### ExaGeoStat
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
The above procedures assume sudo/root access to the system. If that is not the case, the following additional steps need to be
made in order to add your local installation directory (installdir) which would install all the required packages in the
specified directory :
1. All CMake commands need to include -DCMAKE_INSTALL_PREFIX=/path/to/installdir
2. All configure commands need to include -prefix=/path/to/installdir
3. The installation paths for NLOPT, GSL, hwloc, StarPU, Chameleon, STARS-H, and HiCMA need to be added to the PKG_CONFIG_PATH
   environment variable. 

## Verification

---
You can verify your installation by running any of the following examples

1) Synthetic generation of geospatial data with MLE exact computation,
```R
library("exageostatr")  #Load ExaGeoStatR lib.
seed = 0                #Initial seed to generate XY locs.
sigma_sq = 1            #Initial variance.
beta = 0.1              #Initial range.
nu = 0.5                #Initial smoothness.
dmetric = "euclidean"   #"euclidean", or "great_circle".
n = 1600                #n*n locations grid.
exageostat_init(hardware = list (ncores=2, ngpus=0,
                                 ts=320, pgrid=1, qgrid=1))	  #Initiate exageostat instance.
data = simulate_data_exact(sigma_sq, beta, nu,
                                    dmetric, n, seed) 		  #Generate Z observation vector.
result = exact_mle(data, dmetric, optimization = list(clb = c(0.001, 0.001, 0.001), 
                                                      cub = c(5, 5,5 ), 
                                                      tol = 1e-4, max_iters = 20))   #Estimate MLE parameters (Exact).
exageostat_finalize()	#Finalize exageostat instance.
```
========================================================================

2)  Synthetic generation of Geo-spatial data with MLE TLR computation
```R
library("exageostatr") #Load ExaGeoStatR lib.
seed = 0               #Initial seed to generate XY locs.
sigma_sq = 1           #Initial variance.
beta = 0.03            #Initial range.
nu = 0.5               #Initial smoothness.
dmetric = "euclidean"  #"euclidean", or "great_circle".
n = 900                #n*n locations grid.
tlr_acc = 7            #TLR accuracy 10^-(acc).
tlr_maxrank = 450      #TLR Max Rank.

exageostat_init(hardware = list (ncores=2, ngpus=0,
                                 ts=320, lts=600,  pgrid=1, qgrid=1)) #Initiate exageostat instance.
data = simulate_data_exact(sigma_sq, beta, nu, dmetric, n, seed)      #Generate Z observation vector.
result = tlr_mle(data, tlr_acc, tlr_maxrank,  dmetric, 
                 optimization = list(clb = c(0.001, 0.001, 0.001), 
                                     cub = c(5, 5,5 ), tol = 1e-4, 
                                     max_iters = 20))		          #Estimate MLE parameters (TLR).
exageostat_finalize()  #Finalize exageostat instance.
```
========================================================================

3)  Synthetic generation of Geo-spatial data with MLE DST computation
```R
library("exageostatr")  #Load ExaGeoStatR lib.
seed = 0                #Initial seed to generate XY locs.
sigma_sq = 1            #Initial variance.
beta = 0.03             #Initial range.
nu = 0.5                #Initial smoothness.
dmetric = "euclidean"   #"euclidean", or "great_circle".
n = 900                 #n*n locations grid.
dst_band = 3            #Number of diagonal double tiles.
exageostat_init(hardware = list (ncores=4, ngpus=0,
                                 ts=320, lts=0,  pgrid=1, qgrid=1))	  #Initiate exageostat instance.
data = simulate_data_exact(sigma_sq, beta, nu, 
                           dmetric, n, seed) 	                      #Generate Z observation vector.
result = dst_mle(data, dst_band, dmetric, 
                 optimization = list(clb = c(0.001, 0.001, 0.001), 
                                     cub = c(5, 5,5 ), tol = 1e-4, 
                                     max_iters = 20))				 #Estimate MLE parameters (DST).
exageostat_finalize()	#Finalize exageostat instance.
```

========================================================================

4) Synthetic generation of measurements based on given
   geospatial data locations with MLE Exact computation
```r
library("exageostatr")          #Load ExaGeoStatR lib.
sigma_sq = 1                    #Initial variance.
beta = 0.1                      #Initial range.
nu = 0.5                        #Initial smoothness.
dmetric = "euclidean"           #"euclidean", or "great_circle", 
n = 1600                        #n*n locations grid.
x = rnorm(n = 1600, mean = 39.74, sd = 25.09)   #x measurements of n locations.
y = rnorm(n = 1600, mean = 80.45, sd = 100.19)  #y measurements of n locations.
exageostat_init(hardware = list (ncores=2, ngpus=0,
                                 ts=320, lts=0,  pgrid=1, qgrid=1))	 #Initiate exageostat instance.
data = simulate_obs_exact( x, y, sigma_sq, 
                           beta, nu, dmetric) #Generate Z observation vector.
result = exact_mle(data, dmetric, optimization = list(clb = c(0.001, 0.001, 0.001), 
                                                      cub = c(5, 5,5 ), tol = 1e-4, 
                                                      max_iters = 20))
exageostat_finalize()	      #Finalize exageostat instance.
```

