 #
 #
 # Copyright (c) 2017-2020, King Abdullah University of Science and Technology
 # All rights reserved.
 #
 # ExaGeoStat-R is a software package provided by KAUST
 #
 #
 #
 # @file r_zgen_mle_test.R
 # ExaGeoStat R wrapper test example
 #
 # @version 1.0.1
 #
 # @author Sameh Abdulah
 # @date 2019-01-19
library("exageostatr")                                           #Load ExaGeoStat-R lib.
#Sys.setenv(STARPU_HOME = tempdir())
#Sys.setenv(STARPU_HOME = "~/trash")
seed            = 0                                             #Initial seed to generate XY locs.
sigma_sq        = 1                                             #Initial variance.
beta            = 0.1                                           #Initial smoothness.
nu              = 0.5                                           #Initial range.
dmetric         = 0                                             #0 --> Euclidean distance, 1--> great circle distance.
n               = 1600                                          #n*n locations grid.
#theta_out[1:3]                  = -1.99
exageostat_init(hardware = list (ncores=2, ngpus=0, ts=320, pgrid=1, qgrid=1))#Initiate exageostat instance
#Generate Z observation vector
data      = simulate_data_exact(sigma_sq, beta, nu, dmetric, n, seed) #Generate Z observation vector
#Estimate MLE parameters (Exact)
result        = exact_mle(data, dmetric, optimization = list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5,5 ), tol = 1e-4, max_iters = 4))

#print(result)
#Finalize exageostat instance
exageostat_finalize()
