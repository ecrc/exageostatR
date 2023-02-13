#
#
# Copyright (c) 2017-2023, King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file Example2.R
# ExaGeoStat R Performance on Shared Memory Systems for Moderate and Large Sample Size example
#
# @version 1.2.0
#
# @author Sameh Abdulah
# @date 2022-10-22

# The following code shows the usage of the exact_mle function and returns execution time per iteration for one combination of n, ncores and ts

library("exageostatr")                                                              # Load ExaGeoStat-R lib.
hardware = list( ncores = 4 , ngpus = 0 , ts = 320 , pgrid = 1 , qgrid = 1 )        # pecifies the required hardware to execute the code. Here, ncores and ngpus are
                                                                                    # the numbers of CPU cores and GPU accelerators to deploy, ts denotes the tile size
                                                                                    # used for parallelized matrix operations, pgrid and qgrid are the cluster topology parameters
                                                                                    # in case of distributed memory system execution.
exageostat_init(hardware)                                                           # Initiate exageostat instance
data.exageo.reg = simulate_data_exact( kernel = "ugsm-s" , theta = c( 1 , 0.1 , 0.5) , dmetric = "euclidean", n = 1600, seed = 0)
# Estimate MLE parameters (Exact)
result = exact_mle(data.exageo.reg , "ugsm-s", dmetric = "euclidean",
   optimization = list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5, 5 ), tol = 1e-4, max_iters = 20))
time = result$time_per_iter
exageostat_finalize()                                                               # Finalize exageostat instance

# The final results also report the time per iteration, total time, and the number of iterations for each optimization
hardware = list( ncores = 4 , ngpus = 0 , ts = 320 , pgrid = 1 , qgrid = 1 )
exageostat_init(hardware)
result = exact_mle(data.exageo.reg , kernel = "ugsm-s", dmetric = "euclidean",
   optimization = list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5, 5 ), tol = 1e-4, max_iters = 20))
para_mat = result$est_theta
time_mat = c(result$time_per_iter , result$total_time , result$no_iters)
exageostat_finalize()                                                               # Finalize exageostat instance

#In addition, to accelerate the optimization of fields, we minimize the  irrelevant computation by setting gridN = 1
#result = spatialProcess(x = cbind(data$x , data$y) , y = data$z , cov.args = list(Covariance = "Matern",smoothness = 0.6) , gridN = 1 , reltol = 1e-5)
#para_mat = c( result$MLESummary[[7]] , result$MLESummary[[8]] , result$args$smoothness)
#time_mat = c(result$timingTable[3,2]/dim(result$MLEJoint$lnLike.eval)[1] , result$timingTable[ 3 , 2 ] , dim ( result$MLEJoint$lnLike.eval)[1] )