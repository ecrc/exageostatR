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

An easy installation of the above packages is available by using [build-deps.sh](https://github.com/ecrc/exageostatR/blob/master/build_deps.sh)


#### Install latest ExaGeoStat-R version hosted on GitHub
```r
install.packages("devtools")
library(devtools)
install_git(url="https://github.com/ecrc/exageostatR")
library(exageostat)
```


#### Get the latest ExaGeoStat-R release  hosted on GitHub

1. Download exageostat_0.1.0.tar.gz from release
2. Use R to install exageostat_0.1.0.tar.gz
```r
install.packages(repos=NULL, "exageostat_0.1.0.tar.gz")
library(exageostat)
```


Features of ExaGeoStat-R
========================
Operations:

1. Generate synthetic spatial datasets (i.e., locations & environmental measurements).
2. Maximum likelihood evaluation using dense matrices.


More information
================

A more detailed description of the underlying ExaGeoStat software package can be found. [here](https://github.com/ecrc/exageostat)

R Example
================
```r
library("exageostat")					#Load ExaGeoStat-R lib.
theta1		= 1					#Initial variance.
theta2 		= 0.1					#Initial smoothness.
theta3 		= 0.5   				#Initial range.
computation 	= 0					#0 --> exact computation, 1--> LR approx. computation.
dmetric 	= 0					#0 --> Euclidean distance, 1--> great circle distance.
n		= 1600         				#n*n locations grid.
ncores          = 2                                     #Number of underlying CPUs.
gpus		= 0    					#Number of underlying GPUs.
ts		= 320					#Tile_size:  changing it can improve the performance. No fixed value can be given.
p_grid		= 1					#More than 1 in the case of distributed systems 
q_grid		= 1					#More than 1 in the case of distributed systems ( usually equals to p_grid)
clb 		= vector(mode="numeric",length = 3)  	#Optimization function lower bounds values.
cub		= vector(mode="numeric",length = 3)	#Optimization function upper bounds values.
theta_out 	= vector(mode="numeric",length = 3)   	#Parameter vector output.
globalveclen 	= 3*n
vecs_out 	= vector(mode="numeric",length = globalveclen)     #Z measurements of n locations
clb		= as.numeric(c("0.01", "0.01", "0.01"))
cub		= as.numeric(c("5.00", "5.00", "5.00"))
vecs_out[1:globalveclen]	= -1.99
theta_out[1:3]			= -1.99
#Initiate ExaGeoStat instance
exageostat_initR(ncores, gpus, ts)
#Generate Z observation vector
vecs_out	= exageostat_gen_zR(n, ncores, gpus, ts, p_grid, q_grid, theta1, theta2, theta3, computation, dmetric, globalveclen)
#Estimate MLE parameters
theta_out	= exageostat_likelihoodR(n, ncores, gpus, ts, p_grid, q_grid,  vecs_out[1:n],  vecs_out[n+1:(2*n)],  vecs_out[(2*n+1):(3*n)], clb, cub, computation, dmetric)
#Finalize ExaGeoStat instance
exageostat_finalizeR()
```
