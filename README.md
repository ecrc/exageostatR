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


#### Install latest ExaGeoStat-R version hosted on GitHub
```r
install.packages("devtools")
library(devtools)
install_git(url="https://github.com/ecrc/exageostatR")
library(exageostat)
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
library("exageostat")                                           #Load ExaGeoStat-R lib.
seed            = 0                                             #Initial seed to generate XY locs.
theta1          = 1                                             #Initial variance.
theta2          = 0.1                                           #Initial range.
theta3          = 0.5                                           #Initial smoothness.
dmetric         = 0                                             #0 --> Euclidean distance, 1--> great circle distance.
n               = 1600                                          #n*n locations grid.
ncores          = 2                                             #Number of underlying CPUs.
gpus            = 0                                             #Number of underlying GPUs.
ts              = 320                                           #Tile_size:  changing it can improve the performance. No fixed value can be given.
p_grid          = 1                                             #More than 1 in the case of distributed systems
q_grid          = 1                                             #More than 1 in the case of distributed systems ( usually equals to p_grid)
clb             = vector(mode="double",length = 3)             #Optimization function lower bounds values.
cub             = vector(mode="double",length = 3)             #Optimization function upper bounds values.
theta_out       = vector(mode="double",length = 3)             #Parameter vector output.
globalveclen    = 3*n
vecs_out        = vector(mode="double",length = globalveclen)  #Z measurements of n locations
clb             = as.double(c("0.01", "0.01", "0.01"))         #Optimization lower bounds.
cub             = as.double(c("5.00", "5.00", "5.00"))         #Optimization upper bounds.
vecs_out[1:globalveclen]        = -1.99
theta_out[1:3]                  = -1.99
exageostat_initR(ncores, gpus, ts)#Initiate exageostat instance
#Generate Z observation vector
vecs_out        = exageostat_egenzR(n, ncores, gpus, ts, p_grid, q_grid, theta1, theta2, theta3, dmetric, seed, globalveclen) #Generate Z observation vector
#Estimate MLE parameters (Exact)
theta_out       = exageostat_emleR(n, ncores, gpus, ts, p_grid, q_grid,  vecs_out[1:n],  vecs_out[n+1:(2*n)],  vecs_out[(2*n+1):(3*n)], clb, cub, dmetric, 0.0001, 20)
#Finalize exageostat instance
exageostat_finalizeR()
```

2. Test Generating Z vector using random (x, y) locations with TLR MLE computation.
```r
library("exageostat")                                           #Load ExaGeoStat-R lib.
seed            = 0                                             #Initial seed to generate XY locs.
theta1          = 1                                             #Initial variance.
theta2          = 0.03                                          #Initial range.
theta3          = 0.5                                           #Initial smoothness.
dmetric         = 0                                             #0 --> Euclidean distance, 1--> great circle distance.
n               = 900                                           #n*n locations grid.
ncores          = 4                                             #Number of underlying CPUs.
gpus            = 0                                             #Number of underlying GPUs.
dts             = 320                                           #Tile_size:  changing it can improve the performance. No fixed value can be given.
lts             = 600                                           #TLR_Tile_size:  changing it can improve the performance. No fixed value can be given.
p_grid          = 1                                             #More than 1 in the case of distributed systems.
q_grid          = 1                                             #More than 1 in the case of distributed systems ( usually equals to p_grid).
clb             = vector(mode="double", length = 3)            #Optimization function lower bounds values.
cub             = vector(mode="double", length = 3)            #Optimization function upper bounds values.
theta_out       = vector(mode="double", length = 3)            #Parameter vector output.
globalveclen    = 3*n
vecs_out        = vector(mode="double", length = globalveclen) #Z measurements of n locations.
clb             = as.double(c("0.01", "0.01", "0.01"))         #Optimization lower bounds.
cub             = as.double(c("5.00", "5.00", "5.00"))         #Optimization upper bounds.
tlr_acc         = 7                                             #Approximation accuracy 10^-(acc)
tlr_maxrank     = 450                                           #Max Rank
vecs_out[1:globalveclen]        = -1.99
theta_out[1:3]                  = -1.99
#Initiate exageostat instance
exageostat_initR(ncores, gpus, dts)
#Generate Z observation vector
vecs_out        = exageostat_egenzR(n, ncores, gpus, dts, p_grid, q_grid, theta1, theta2, theta3, dmetric, seed, globalveclen)
#Estimate MLE parameters (TLR approximation)
theta_out       = exageostat_tlrmleR(n, ncores, gpus, lts, p_grid, q_grid,  vecs_out[1:n],  vecs_out[n+1:(2*n)],  vecs_out[(2*n+1):(3*n)], clb, cub, tlr_acc, tlr_maxrank,  dmetric, 0.0001, 20)
#Finalize exageostat instance
exageostat_finalizeR()
```

3. Test Generating Z vector using random (x, y) locations with DST MLE computation.
```r
library("exageostat")                                           #Load ExaGeoStat-R lib.
seed            = 0                                             #Initial seed to generate XY locs.
theta1          = 1                                             #Initial variance.
theta2          = 0.03                                          #Initial range.
theta3          = 0.5                                           #Initial smoothness.
dmetric         = 0                                             #0 --> Euclidean distance, 1--> great circle distance.
n               = 900                                           #n*n locations grid.
ncores          = 4                                             #Number of underlying CPUs.
gpus            = 0                                             #Number of underlying GPUs.
ts              = 320                                           #Tile_size:  changing it can improve the performance. No fixed value can be given.
p_grid          = 1                                             #More than 1 in the case of distributed systems.
q_grid          = 1                                             #More than 1 in the case of distributed systems ( usually equals to p_grid).
clb             = vector(mode="double", length = 3)            #Optimization function lower bounds values.
cub             = vector(mode="double", length = 3)            #Optimization function upper bounds values.
theta_out       = vector(mode="double", length = 3)            #Parameter vector output.
globalveclen    = 3*n
vecs_out        = vector(mode="double", length = globalveclen) #Z measurements of n locations.
clb             = as.double(c("0.01", "0.01", "0.01"))         #Optimization lower bounds.
cub             = as.double(c("5.00", "5.00", "5.00"))         #Optimization upper bounds.
dst_thick       = 3                                             #Number of used Diagonal Super Tile (DST).
vecs_out[1:globalveclen]        = -1.99
theta_out[1:3]                  = -1.99
#Initiate exageostat instance
exageostat_initR(ncores, gpus, ts)
#Generate Z observation vector
vecs_out        = exageostat_egenzR(n, ncores, gpus, ts, p_grid, q_grid, theta1, theta2, theta3, dmetric, seed, globalveclen)
#Estimate MLE parameters (DST approximation)
theta_out       = exageostat_dstmleR(n, ncores, gpus, ts, p_grid, q_grid,  vecs_out[1:n],  vecs_out[n+1:(2*n)],  vecs_out[(2*n+1):(3*n)], clb, cub, dst_thick,  dmetric, 0.0001, 20)
#Finalize exageostat instance
exageostat_finalizeR()
```
4. Test Generating Z vector using given (x, y) locations with exact MLE computation.
```r
library("exageostat")                                                   #Load ExaGeoStat-R lib.
theta1          = 1                                                     #Initial variance.
theta2          = 0.1                                                   #Initial range.
theta3          = 0.5                                                   #Initial smoothness.
dmetric         = 0                                                     #0 --> Euclidean distance, 1--> great circle distance.
n               = 1600                                                  #n*n locations grid.
ncores          = 2                                                     #Number of underlying CPUs.
gpus            = 0                                                     #Number of underlying GPUs.
ts              = 320                                                   #Tile_size:  changing it can improve the performance. No fixed value can be given.
p_grid          = 1                                                     #More than 1 in the case of distributed systems
q_grid          = 1                                                     #More than 1 in the case of distributed systems ( usually equals to p_grid)
clb             = vector(mode="double",length = 3)                     #Optimization function lower bounds values.
cub             = vector(mode="double",length = 3)                     #Optimization function upper bounds values.
theta_out       = vector(mode="double",length = 3)                     #Parameter vector output.
globalveclen    = n
vecs_out        = vector(mode="double",length = globalveclen)          #Z measurements of n locations.
x               = rnorm(n = globalveclen, mean = 39.74, sd = 25.09)     #x measurements of n locations.
y               = rnorm(n = globalveclen, mean = 80.45, sd = 100.19)    #y measurements of n locations.
clb             = as.double(c("0.01", "0.01", "0.01"))                 #Optimization lower bounds.
cub             = as.double(c("5.00", "5.00", "5.00"))                 #Optimization upper bounds.
vecs_out[1:globalveclen]        = -1.99
theta_out[1:3]                  = -1.99
#Initiate exageostat instance
exageostat_initR(ncores, gpus, ts)
#Generate Z observation vector based on given locations
vecs_out        = exageostat_egenz_glR(n, ncores, gpus, ts, p_grid, q_grid, x, y, theta1, theta2, theta3, dmetric, globalveclen)
#Estimate MLE parameters (Exact)
theta_out       = exageostat_emleR(n, ncores, gpus, ts, p_grid, q_grid,  x,  y,  vecs_out, clb, cub, dmetric, 0.0001, 20)
#Finalize exageostat instance
exageostat_finalizeR()
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
