ExaGeoStatR
===========

`ExaGeoStatR` is an R-Wrapper for [ExaGeoStat framework]((https://github.com/ecrc/exageostat), a parallel high performance unified software for geostatistics on manycore systems.


ExaGeoStatR v1.0.1
==================
1. Major changes in the structure of the package to meet CRAN requirements and to facilitate the installation on different platforms. 


Previous Versions
=================
### ExaGeoStatR v0.1.0

1. Large-scale synthetic Geostatistics data generator.
2. Support exact computation of the Maximum Likelihood Estimation (MLE) function using shared-memory, GPUS, or distributed-memory systems

### ExaGeoStatR v1.0.0
1. Support approximate computation (i.e., Diagonal Super-Tile (DST) and Tile Low-Rank (TLR)  of the Maximum Likelihood Estimation (MLE) function using shared-memory, GPUS, or distributed-memory systems.

Getting Started
===============

### Installation

For more details, you can check the complete [Installation Guide](./InstallationGuide.md)

#### Software dependencies
1. BLAS/CBLAS/LAPACK/LAPACKE optimized implementation, ex.,  AMD Core Math Library (ACML), Arm Performance Libraries, ATLAS, Intel Math Kernel Library (MKL), or OpenBLAS.
2. [Portable Hardware Locality (hwloc)](https://www.open-mpi.org/projects/hwloc/).
3. [NLopt](https://nlopt.readthedocs.io/en/latest/).
4. [GNU Scientific Library (GSL)](https://www.gnu.org/software/gsl/doc/html/index.html).
5. [StarPU](http://starpu.gforge.inria.fr/).
6. [Chameleon](https://project.inria.fr/chameleon/).
7. [HiCMA](https://github.com/ecrc/hicma/).
8. [STARS-H](https://github.com/ecrc/stars-h/).

All these dependencies are automatically installed with the package if not exist (OpenBLAS is the default BLAS library) on the system (ExaGeoStatR v1.0.1).


#### Install latest ExaGeoStatR version hosted on GitHub (parallel installation)
```r
library("devtools")
Sys.setenv(MKLROOT="/opt/intel/mkl")
install_git(url="https://github.com/ecrc/exageostatR")
```


#### Install latest ExaGeoStatR version hosted on GitHub (sequential installation)
```r
library("devtools")
Sys.setenv(MKLROOT="/opt/intel/mkl")
Sys.setenv(MAKE="make -j 1")
install_git(url="https://github.com/ecrc/exageostatR")
```


#### Install latest ExaGeoStatR version hosted on GitHub with GPU support
```r
library("devtools")
Sys.setenv(MKLROOT="/opt/intel/mkl")
install_git(url="https://github.com/ecrc/exageostatR", configure.args=C('--enable-cuda'))
```

#### Install latest ExaGeoStatR version hosted on GitHub with MPI support
```r
library("devtools")
Sys.setenv(MKLROOT="/opt/intel/mkl")
install_git(url="https://github.com/ecrc/exageostatR", configure.args=C('--enable-mpi'))
```

#### Get the latest ExaGeoStatR release  hosted on GitHub)
1. Download exageostat_1.0.1.tar.gz from release)
2. Use R to install exageostat_1.0.1.tar.gz)

```r
install.packages(repos=NULL, "exageostat_1.0.1.tar.gz")
```


Features of ExaGeoStatR
========================
Operations:

1. Generate synthetic spatial datasets (i.e., locations & environmental measurements).
2. Maximum likelihood evaluation using dense matrices.
3. Maximum likelihood evaluation using compressed matrices based on Tile Low-Rank(TLR).
4. Maximum likelihood evaluation using matrices based on Diagonal Super-Tile(DST).

More information
================

A more detailed description of the underlying ExaGeoStat software package can be found. [here](https://github.com/ecrc/exageostat)

R Examples
================
1. Test Generating Z vector using random (x, y) locations with exact MLE computation.
```r
library("exageostatr")                                        #Load ExaGeoStatR lib.
seed          = 0                                             #Initial seed to generate XY locs.
sigma_sq      = 1                                             #Initial variance.
beta          = 0.1                                           #Initial range.
nu            = 0.5                                           #Initial smoothness.
dmetric      = "euclidean"                                    #"euclidean", or "great_circle".
n             = 1600                                          #n*n locations grid.
exageostat_init(hardware = list (ncores=2, ngpus=0, 
ts=320, pgrid=1, qgrid=1))				      #Initiate exageostat instance.
data          = simulate_data_exact(sigma_sq, beta, nu,
dmetric, n, seed) 					      #Generate Z observation vector.
result        = exact_mle(data, dmetric, optimization = list(clb = c(0.001, 0.001, 0.001),
cub = c(5, 5,5 ), tol = 1e-4, max_iters = 20))                #Estimate MLE parameters (Exact).
exageostat_finalize()					      #Finalize exageostat instance.
```

2. Test Generating Z vector using random (x, y) locations with TLR MLE computation.
```r
library("exageostatr")                                        #Load ExaGeoStatR lib.
seed            = 0                                           #Initial seed to generate XY locs.
sigma_sq        = 1                                           #Initial variance.
beta            = 0.03                                        #Initial range.
nu              = 0.5                                         #Initial smoothness.
dmetric         = "euclidean"                                 #"euclidean", or "great_circle".
n               = 900                                         #n*n locations grid.
tlr_acc         = 7                                           #TLR accuracy 10^-(acc).
tlr_maxrank     = 450                                         #TLR Max Rank.

exageostat_init(hardware = list (ncores=2, ngpus=0, 
ts=320, lts=600,  pgrid=1, qgrid=1))			      #Initiate exageostat instance.
data         	= simulate_data_exact(sigma_sq, beta, nu,
dmetric, n, seed) 					      #Generate Z observation vector.
result       	= tlr_mle(data, tlr_acc, tlr_maxrank,  dmetric, optimization = 
list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5,5 ),
tol = 1e-4, max_iters = 20))				      #Estimate MLE parameters (TLR).
exageostat_finalize() 				   	      #Finalize exageostat instance.
```

3. Test Generating Z vector using random (x, y) locations with DST MLE computation.
```r
library("exageostatr")                                        #Load ExaGeoStatR lib.
seed            = 0                                           #Initial seed to generate XY locs.
sigma_sq        = 1                                           #Initial variance.
beta            = 0.03                                        #Initial range.
nu              = 0.5                                         #Initial smoothness.
dmetric         = "euclidean"                                 #"euclidean", or "great_circle".
n               = 900                                         #n*n locations grid.
dst_band       = 3                                            #Number of diagonal double tiles.
exageostat_init(hardware = list (ncores=4, ngpus=0,
ts=320, lts=0,  pgrid=1, qgrid=1))			      #Initiate exageostat instance.
data      	= simulate_data_exact(sigma_sq, beta, nu,
dmetric, n, seed) 					      #Generate Z observation vector.
result       	= dst_mle(data, dst_band, dmetric, optimization = 
list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5,5 ),
 tol = 1e-4, max_iters = 20))				      #Estimate MLE parameters (DST).
exageostat_finalize()					      #Finalize exageostat instance.
```
4. Test Generating Z vector using given (x, y) locations with exact MLE computation.
```r
library("exageostatr")                                        #Load ExaGeoStatR lib.
sigma_sq        = 1                                           #Initial variance.
beta            = 0.1                                         #Initial range.
nu              = 0.5                                         #Initial smoothness.
dmetric         = "euclidean"                                 #"euclidean", or "great_circle", 
n               = 1600                                        #n*n locations grid.
x               = rnorm(n = 1600, mean = 39.74, sd = 25.09)   #x measurements of n locations.
y               = rnorm(n = 1600, mean = 80.45, sd = 100.19)  #y measurements of n locations.
exageostat_init(hardware = list (ncores=2, ngpus=0,
ts=320, lts=0,  pgrid=1, qgrid=1))			      #Initiate exageostat instance.
data            = simulate_obs_exact( x, y, sigma_sq,
 beta, nu, dmetric) 					      #Generate Z observation vector.
result          = exact_mle(data, dmetric, optimization = 
list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5,5 ), tol = 1e-4, max_iters = 20))
exageostat_finalize()					      #Finalize exageostat instance.
```
Batch R script to distributed environment example
=================================================
```r
#!/bin/bash
#SBATCH --job-name=job_name
#SBATCH --output=output_file.txt
#SBATCH --partition=XXXX
#SBATCH --nodes=4
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=31
#SBATCH --time 00:30:00

# RExample.r includes one of the examples above
srun Rscript RExample.r
```

