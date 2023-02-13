#
# Copyright (c) 2017-2023, King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file tlr_mle_test.R
# ExaGeoStat R wrapper test example
#
# @version 1.2.0
#
# @author Sameh Abdulah
# @date 2019-01-19
library("exageostatr")                                          # Load ExaGeoStat-R lib.

seed            = 0                                             # Initial seed to generate XY locs.
sigma_sq        = 1                                             # Initial variance.
beta            = 0.03                                          # Initial smoothness.
nu  	        = 0.5                                           # Initial range.
dmetric         = "euclidean"                                   # 0 --> Euclidean distance, 1--> great circle distance.
n               = 900                                           # n*n locations grid.
tlr_acc         = 7                                             # Approximation accuracy 10^-(acc)
tlr_maxrank     = 450                                           # Max Rank
theta = c(sigma_sq, beta, nu)

# Initiate exageostat instance
exageostat_init(hardware = list (ncores = 2, ngpus = 0, ts = 320, lts = 600,  pgrid = 1, qgrid = 1))

# Generate Z observation vector
data         = simulate_data_exact("ugsm-s", theta, dmetric, n, seed)

# Estimate MLE parameters (TLR approximation)
result       = tlr_mle(data, "ugsm-s", tlr_acc, tlr_maxrank,  dmetric, optimization = 
                       list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5,5 ), tol = 1e-4, max_iters = 4))

# Finalize exageostat instance
exageostat_finalize()