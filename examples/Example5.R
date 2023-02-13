#
#
# Copyright (c) 2017-2023, King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file Example3.R
# ExaGeoStat R Extreme Computing on Distributed Memory Systems example
#
# @version 1.2.0
#
# @author Sameh Abdulah
# @date 2022-10-22

# Another example of the usage of ExaGeoStatR on a distributed memory system with 31 CPU cores, 4 × 4 rectangular array of nodes, ts=960 and, n=250,000 is shown below
library("exageostatr")                                                              # Load ExaGeoStat-R lib.
n = 250000
hardware = list( ncores = 4 , ts = 960 , pgrid = 4 , qgrid = 4 )        # pecifies the required hardware to execute the code. Here, ncores and ngpus are
# the numbers of CPU cores and GPU accelerators to deploy, ts denotes the tile size
# used for parallelized matrix operations, pgrid and qgrid are the cluster topology parameters
# in case of distributed memory system execution.

exageostat_init(hardware)                                               # Initiate exageostat instance
data = simulate_data_exact( kernel = "ugsm-s" , theta = c( 1 , 0.1 , 0.5) , dmetric = "euclidean", n, seed = 0)
result_cpu = exact_mle(data, kernel = "ugsm-s", dmetric = "euclidean",
   optimization = list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5, 5 ), tol = 1e-4, max_iters = 20))
time_cpu = result_cpu$time_per_iter
exageostat_finalize()                                                               # Finalize exageostat instance


