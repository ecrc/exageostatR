#
#
# Copyright (c) 2017-2023, King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file exact_mle_test.R
# ExaGeoStat R wrapper test example
#
# @version 1.2.0
#
# @author Sameh Abdulah
# @date 2019-01-19
library("exageostatr")                                          # Load ExaGeoStat-R lib.
seed            = 0                                             # Initial seed to generate XY locs.
sigma_sq        = 1                                             # Initial variance.
beta            = 0.1                                           # Initial smoothness.
nu              = 0.5                                           # Initial range.
dmetric         = "euclidean"                                   # 0 --> Euclidean distance, 1--> great circle distance.
n               = 400                                           # n*n locations grid.
theta=c(sigma_sq, beta, nu)

# Initiate ExaGeoStat instance
exageostat_init(hardware = list (ncores = 25, ngpus = 0, ts = 320, pgrid = 1, qgrid = 1))

# Generate Z observation vector
data      = simulate_data_exact("ugsm-s", theta, dmetric, n, seed) 

# Estimate MLE parameters (Exact)
result    = exact_mle(data, "ugsm-s", dmetric, optimization = 
                      list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5, 5 ), tol = 1e-5, max_iters = 4))

est_theta = c(result[[1]], result[[2]], result[[3]])

result_mloe = exact_mloe_mmom( list(x_train=data$x, y_train=data$y, z_train=data$z, x_test=data$x, y_test=data$y), "ugsm-s", dmetric, est_theta, theta)

result_fisher = fisher_general(list(x=data$x, y=data$y),  c(result[[1]], result[[2]], result[[3]]), dmetric)

# Finalize exageostat instance
exageostat_finalize()
