ExaGeoStatR
===========

`ExaGeoStatR` is an R-Wrapper for [ExaGeoStat framework]((https://github.com/ecrc/exageostat), a parallel high performance unified software for geostatistics on manycore systems.


ExaGeoStatR v1.2.0
==================
1. Large-scale synthetic Geostatistics data generator.
2. Support exact computation of the Maximum Likelihood Estimation (MLE) function using shared-memory, GPUS, or distributed-memory systems.
3. Support exact prediction
4. Support approximate computation (i.e., Diagonal Super-Tile (DST) and Tile Low-Rank (TLR)  of the Maximum Likelihood Estimation (MLE) function using shared-memory, GPUS, or distributed-memory systems.


Getting Started
===============

### Installation

#### Software dependencies
1. BLAS/CBLAS/LAPACK/LAPACKE optimized implementation, ex.,  AMD Core Math Library (ACML), Arm Performance Libraries, ATLAS, Intel Math Kernel Library (MKL), or OpenBLAS.
2. [Portable Hardware Locality (hwloc)](https://www.open-mpi.org/projects/hwloc/).
3. [NLopt](https://nlopt.readthedocs.io/en/latest/).
4. [GNU Scientific Library (GSL)](https://www.gnu.org/software/gsl/doc/html/index.html).
5. [StarPU](http://starpu.gforge.inria.fr/).
6. [Chameleon](https://project.inria.fr/chameleon/).
7. [HiCMA](https://github.com/ecrc/hicma/).

All these dependencies are automatically installed with the package if not exist (OpenBLAS is the default BLAS library) on the system (ExaGeoStatR v1.2.0).


### Prerequisites
We recommend you install these libraries before beginning to ensure you get all of them while using the R examples.
#### [devtools](https://www.r-project.org/nosvn/pandoc/devtools.html)
For installation, type at the R prompt:
```R
install.packages("devtools")
```

#### [GeoR](https://cran.r-project.org/web/packages/geoR/index.html)
For installation, type at the R prompt:
```R
install.packages("geoR")
```
Or

1. Download the latest geoR version (*.tar.gz) from http://www.leg.ufpr.br/geoR

2. Install from the linux prompt (with root/sudo permissions) replacing "*" below by the current version number.
```R
R CMD INSTALL geoR*.tar.gz
```

#### [Fields](https://cran.r-project.org/web/packages/fields/index.html)
For installation, type at the R prompt:
```R
install.packages("fields", dependencies = TRUE)
```

#### [spam](https://cran.r-project.org/web/packages/spam/index.html)
For installation, type at the R prompt:
```R
install.packages("spam")
```

#### [GpGp](https://cran.r-project.org/web/packages/GpGp/index.html)
For installation, type at the R prompt:
```R
install.packages("GpGp")
```

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
1. Download exageostat_1.2.0.tar.gz from release)
2. Use R to install exageostat_1.2.0.tar.gz)

```r
install.packages(repos=NULL, "exageostat_1.2.0.tar.gz")
```

#### Install latest ExaGeoStatR version hosted on GitHub with MPI support
```r
library("devtools")
Sys.setenv(MKLROOT="/opt/intel/mkl")
install_git(url="https://github.com/ecrc/exageostatR", configure.args=C('--enable-mpi'))
```

Features of ExaGeoStatR
========================
Operations:

1. Generate synthetic spatial datasets (i.e., locations & environmental measurements).
2. Maximum likelihood evaluation using dense matrices.
3. Maximum likelihood evaluation using compressed matrices based on Tile Low-Rank(TLR).
4. Maximum likelihood evaluation using matrices based on Diagonal Super-Tile(DST).
5. Predicting missing values on predefined spatial locations.


Supported Covariance Functions
==============================
1. Univariate Matérn (Gaussian/Stationary)
2. Univariate Matérn with Nugget (Gaussian/Stationary)
3. Flexible Bivariate Matérn (Gaussian/Stationary)
4. Parsimonious Bivariate Matérn (Gaussian/Stationary)
5. Parsimonious trivariate Matérn (Gaussian/Stationary)
6. Univariate Space/Time Matérn (Gaussian/Stationary)
7. Bivariate Space/Time Matérn (Gaussian/Stationary)
8. Tukey g-and-h Univariate Matérn (non-Gaussian/Stationary)
9. Tukey g-and-h Univariate Power Exponential (non-Gaussian/Stationary)

R Examples
================
User can find many test examples in `tests` directory. 

#### Example of Batch Job Script to Submit an R Script to Distributed Environment

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

# RExample.r includes one of the examples in the `tests` directory.
srun Rscript RExample.r
```

Known Issues
=============
### Intel MKL FATAL ERROR
##### Error
```
Intel MKL FATAL ERROR: Cannot load libmkl_avx512.so or libmkl_def.so
```
or 
```
symbol lookup error: /opt/PATH_TO_MKL/lib/intel64/libmkl_intel_thread.so: undefined symbol: __kmpc_global_thread_num
```
#### Solution 
[Intel community solution](https://community.intel.com/t5/Intel-DevCloud/Intel-MKL-FATAL-ERROR-Cannot-load-libmkl-avx512-so-or-libmkl-def/td-p/1169754)

We recommend the following solution:
1. Navigate to installed mkl directory and find the exact path of libmkl_def.so
2. Export the following command.
```
export LD_PRELOAD=/PATH_TO_MKL/lib/intel64/libmkl_def.so:/PATH_TO_MKL/lib/intel64/libmkl_avx2.so:/PATH_TO_MKL/lib/intel64/libmkl_core.so:/PATH_TO_MKL/lib/intel64/libmkl_intel_lp64.so:/PATH_TO_MKL/lib/intel64/libmkl_intel_thread.so:/PATH_TO_MKL/lib/intel64/libiomp5.so
```

Notes
=================
1. The `data` directory includes datasets from the "Competition on Spatial Statistics for Large Datasets" manuscript ([here](https://link.springer.com/article/10.1007/s13253-021-00457-z)).
2. GeoR, Fields, spam, and GpGp packages are only required to run some examples related to the benchmarking framework.

