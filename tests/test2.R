 #
#
# Copyright (c) 2017-2019, King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file test2.R
# ExaGeoStat R wrapper test example
#
# @version 1.0.0
#
# @author Sameh Abdulah
# @date 2019-01-19
library("exageostat")                                           #Load ExaGeoStat-R lib.
seed            = 0                                             #Initial seed to generate XY locs.
sigma_sq        = 1                                             #Initial variance.
beta            = 0.03                                          #Initial smoothness.
nu	        = 0.5                                           #Initial range.
dmetric         = 0                                             #0 --> Euclidean distance, 1--> great circle distance.
n               = 900                                           #n*n locations grid.
tlr_acc         = 7                                             #Approximation accuracy 10^-(acc)
tlr_maxrank     = 450                                           #Max Rank

#Initiate exageostat instance
exageostat_init(hardware = list (ncores=2, ngpus=0, ts=320, lts=600,  pgrid=1, qgrid=1))#Initiate exageostat instance
#Generate Z observation vector
data      = simulate_data_exact(sigma_sq, beta, nu, dmetric, n, seed) #Generate Z observation vecto
#Estimate MLE parameters (TLR approximation)
result       = tlr_mle(data, tlr_acc, tlr_maxrank,  dmetric, optimization = list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5,5 ), tol = 1e-4, max_iters = 20))
#print(result)
#Finalize exageostat instance
exageostat_finalize()
