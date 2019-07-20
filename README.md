ExaGeoStat-R
============

`ExaGeoStat-R` is an R-Wrapper for [ExaGeoStat framework]((https://github.com/ecrc/exageostat)), a parallel high performance unified framework for geostatistics on manycore systems.

Getting Started
===============

### Installation

#### Software dependencies
1. [Portable Hardware Locality (hwloc)](https://www.open-mpi.org/projects/hwloc/).
2. [NLopt](https://nlopt.readthedocs.io/en/latest/).
3. [GNU Scientific Library (GSL)](https://www.gnu.org/software/gsl/doc/html/index.html).
4. [StarPU](http://starpu.gforge.inria.fr/).
5. [Chameleon](https://project.inria.fr/chameleon/).
6. [Hicma](https://github.com/ecrc/hicma/).
7. [Stars-H](https://github.com/ecrc/stars-h/).
An easy installation of the above packages is available by using [build-deps.sh](https://github.com/ecrc/exageostatR/blob/master/build_deps.sh)


#### Install latest ExaGeoStat-R version hosted on GitHub(parallel installation)
```r
install.packages("devtools")
library("devtools")
Sys.setenv(PKG_CONFIG_PATH=paste(Sys.getenv("PKG_CONFIG_PATH"),paste(.libPaths(),"exageostat/lib/pkgconfig",sep='/',collapse=':'),sep=':'))
Sys.setenv(MKLROOT="/opt/intel/mkl")
install_git(url="https://github.com/ecrc/exageostatR-dev")
```


#### Install latest ExaGeoStat-R version hosted on GitHub (sequential installation)
```r
install.packages("devtools")
library("devtools")
Sys.setenv(PKG_CONFIG_PATH=paste(Sys.getenv("PKG_CONFIG_PATH"),paste(.libPaths(),"exageostat/lib/pkgconfig",sep='/',collapse=':'),sep=':'))
Sys.setenv(MKLROOT="/opt/intel/mkl")
Sys.setenv(MAKE="make -j 1")
install_git(url="https://github.com/ecrc/exageostatR-dev")
```


#### Get the latest ExaGeoStat-R release  hosted on GitHub

1. Download exageostat_1.0.0.tar.gz from release
2. Use R to install exageostat_1.0.0.tar.gz
```r
install.packages(repos=NULL, "exageostat_1.0.0.tar.gz")
library(exageostat)
```


Features of ExaGeoStat-R
========================
Operations:

1. Generate synthetic spatial datasets (i.e., locations & environmental measurements).
2. Maximum likelihood evaluation using dense matrices.
3. Maximum likelihood evaluation using compressed matrices based on Tile Low-Rank(TLR).
4. Maximum likelihood evaluation using  matrices based on Diagonal Super-Tile(DST).

More information
================

A more detailed description of the underlying ExaGeoStat software package can be found. [here](https://github.com/ecrc/exageostat)

R Examples
================
1. Test Generating Z vector using random (x, y) locations with exact MLE computation.
```r
library("exageostat")                                          #Load ExaGeoStat-R lib.
seed          = 0                                             #Initial seed to generate XY locs.
sigma_sq      = 1                                             #Initial variance.
beta          = 0.1                                           #Initial smoothness.
nu            = 0.5                                           #Initial range.
dmetric       = 0                                             #0 --> Euclidean distance, 1--> great circle distance.
n             = 1600                                          #n*n locations grid.
#theta_out[1:3]                  = -1.99
exageostat_init(hardware = list (ncores=2, ngpus=0, ts=320, pgrid=1, qgrid=1))#Initiate exageostat instance
#Generate Z observation vector
data          = simulate_data_exact(sigma_sq, beta, nu, dmetric, n, seed) #Generate Z observation vector
#Estimate MLE parameters (Exact)
result        = exact_mle(data, dmetric, optimization = list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5,5 ), tol = 1e-4, max_iters = 20))

#print(result)
#Finalize exageostat instance
exageostat_finalize()
```

2. Test Generating Z vector using random (x, y) locations with TLR MLE computation.
```r
library("exageostat")                                           #Load ExaGeoStat-R lib.
seed            = 0                                             #Initial seed to generate XY locs.
sigma_sq        = 1                                             #Initial variance.
beta            = 0.03                                          #Initial smoothness.
nu              = 0.5                                           #Initial range.
dmetric         = 0                                             #0 --> Euclidean distance, 1--> great circle distance.
n               = 900                                           #n*n locations grid.
tlr_acc         = 7                                             #Approximation accuracy 10^-(acc)
tlr_maxrank     = 450                                           #Max Rank

#Initiate exageostat instance
exageostat_init(hardware = list (ncores=2, ngpus=0, ts=320, lts=600,  pgrid=1, qgrid=1))#Initiate exageostat instance
#Generate Z observation vector
data         = simulate_data_exact(sigma_sq, beta, nu, dmetric, n, seed) #Generate Z observation vecto
#Estimate MLE parameters (TLR approximation)
result       = tlr_mle(data, tlr_acc, tlr_maxrank,  dmetric, optimization = list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5,5 ), tol = 1e-4, max_iters = 20))
#print(result)
#Finalize exageostat instance
exageostat_finalize()
```

3. Test Generating Z vector using random (x, y) locations with DST MLE computation.
```r
library("exageostat")                                           #Load ExaGeoStat-R lib.
seed            = 0                                             #Initial seed to generate XY locs.
sigma_sq        = 1                                             #Initial variance.
beta            = 0.03                                          #Initial smoothness.
nu              = 0.5                                           #Initial range.
dmetric         = 0                                             #0 --> Euclidean distance, 1--> great circle distance.
n               = 900                                           #n*n locations grid.
dst_thick       = 3                                             #Number of used Diagonal Super Tile (DST).
#Initiate exageostat instance
exageostat_init(hardware = list (ncores=4, ngpus=0, ts=320, lts=0,  pgrid=1, qgrid=1))
#Generate Z observation vector
data      = simulate_data_exact(sigma_sq, beta, nu, dmetric, n, seed) #Generate Z observation vecto
#Estimate MLE parameters (DST approximation)
result       = dst_mle(data, dst_thick, dmetric, optimization = list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5,5 ), tol = 1e-4, max_iters = 20))
#print(result)
#Finalize exageostat instance
exageostat_finalize()
```
4. Test Generating Z vector using given (x, y) locations with exact MLE computation.
```r
library("exageostat")                                                   #Load ExaGeoStat-R lib.
sigma_sq        = 1                                                     #Initial variance.
beta            = 0.1                                                   #Initial smoothness.
nu              = 0.5                                                   #Initial range.
dmetric         = 0                                                     #0 --> Euclidean distance, 1--> great circle distance.
n               = 1600                                                  #n*n locations grid.
x               = rnorm(n = 1600, mean = 39.74, sd = 25.09)     #x measurements of n locations.
y               = rnorm(n = 1600, mean = 80.45, sd = 100.19)    #y measurements of n locations.
#Initiate exageostat instance
exageostat_init(hardware = list (ncores=2, ngpus=0, ts=320, lts=0,  pgrid=1, qgrid=1))#Initiate exageostat instance
#Generate Z observation vector based on given locations
data          = simulate_obs_exact( x, y, sigma_sq, beta, nu, dmetric)
#Estimate MLE parameters (Exact)
result        = exact_mle(data, dmetric, optimization = list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5,5 ), tol = 1e-4, max_iters = 20))
#print(result)
#Finalize exageostat instance
exageostat_finalize()
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

srun Rscript Rtest.r
```
