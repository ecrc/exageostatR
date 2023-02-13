#
#
# Copyright (c) 2017-2023, King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file dst_mle_loaded_data_test.R
# ExaGeoStat R wrapper test example
#
# @version 1.2.0

# @author Kesen Wang
# @date 2021-12-08

library("exageostatr")                                          #Load ExaGeoStat-R lib.

dmetric         = "euclidean"                                   #0 --> Euclidean distance, 1--> great circle distance.
dst_thick       = 3                                             #Number of used Diagonal Super Tile (DST).


WORKDIR <- Sys.getenv("PWD")
FILE_PATH <- paste(WORKDIR, "/../exageostatr/data/Data.rda", sep = "")

load(file=FILE_PATH)                                  #load data

# Initiate exageostat instance
exageostat_init(hardware = list (ncores = 4, ngpus = 0, ts = 320, lts = 0,  pgrid = 1, qgrid = 1))

# Convert data type
data=list("x" = Data1Large$x, "y" = Data1Large$y, "z" = Data1Large$z)   

# Estimate MLE parameters (DST approximation)
result       = dst_mle(data, "ugsm-s", dst_thick, dmetric, optimization =
                       list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5,5 ), tol = 1e-4, max_iters =10))

print(result)

# Finalize exageostat instance
exageostat_finalize()