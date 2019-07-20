#
#
# Copyright (c) 2017, King Abdullah University of Science and Technology
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
# @date 2019-01-17
library("exageostat")                                           #Load ExaGeoStat-R lib.
seed            = 0                                             #Initial seed to generate XY locs.
sigma_sq        = 1                                             #Initial variance.
beta    	= 0.03                                          #Initial smoothness.
nu  	        = 0.5                                           #Initial range.
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
