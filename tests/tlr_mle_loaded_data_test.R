#
#
# Copyright (c) 2017-2023, King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file tlr_mle_loaded_data_test.R
# ExaGeoStat R wrapper test example
#
# @version 1.2.0

# @author Kesen Wang
# @date 2021-12-08

library("exageostatr")                                          # Load ExaGeoStat-R lib.

dmetric         = "euclidean"                                   # 0 --> Euclidean distance, 1--> great circle distance.
tlr_acc         = 7                                             # Approximation accuracy 10^-(acc)
tlr_maxrank     = 450                                           # Max Rank

WORKDIR <- Sys.getenv("PWD")
FILE_PATH <- paste(WORKDIR, "/../exageostatr/data/Data.rda", sep = "")

load(file=FILE_PATH)                                  #load data

# Convert data for input
data = list("x" = as.numeric(Data1Large$x), "y" = as.numeric(Data1Large$y), "z" = as.numeric(Data1Large$z))                                       
# Initiate exageostat instance
exageostat_init(hardware = list (ncores = 2, ngpus = 0, ts = 320, lts = 1000,  pgrid = 1, qgrid = 1))#Initiate exageostat instance

# Estimate MLE parameters with tile low rank method

result       = tlr_mle(data, "ugsm-s", tlr_acc, tlr_maxrank,  dmetric, optimization = list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5,5 ), tol = 1e-4, max_iters = 2))
print(result)

# Compute Fisher matrix
fisher_general(data, c(1,1,1), dmetric)

# Finalize exageostat instance
exageostat_finalize()