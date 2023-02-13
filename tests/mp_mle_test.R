#
#
# Copyright (c) 2017-2023, King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file mp_mle_test.R
# ExaGeoStat R wrapper test example
#
# @version 1.2.0

# @author Kesen Wang
# @date 2020-12-08
#library("exageostatr")                                          #Load ExaGeoStat-R lib.
#seed            = 0                                             #Initial seed to generate XY locs.
#sigma_sq        = 1                                             #Initial variance.
#beta        	= 0.03                                          #Initial smoothness.
#nu  	        = 0.5                                           #Initial range.
#dmetric         = "euclidean"                                   #0 --> Euclidean distance, 1--> great circle distance.
#n               = 900                                           #n*n locations grid.
#mp_band         = 3                                             #Number of used Mixed Precision (MP).
#theta=c(sigma_sq, beta, nu)
# Initiate exageostat instance

#exageostat_init(hardware = list (ncores = 4, ngpus = 0, ts = 320, lts = 0,  pgrid = 1, qgrid = 1))

# Generate Z observation vector
#data      = simulate_data_exact("ugsm-s", theta, dmetric, n, seed)

# Estimate MLE parameters (MP  approximation)
#result    = mp_mle(data, "ugsm-s", mp_band, dmetric, optimization =
#		   list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5,5 ), tol = 1e-4, max_iters = 1000))

# Finalize exageostat instance
#exageostat_finalize()