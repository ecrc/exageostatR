#
#
# Copyright (c) 2017-2023, King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file Example1.R
# ExaGeoStat R Data Generation example
#
# @version 1.2.0
#
# @author Sameh Abdulah
# @date 2022-10-22

# The code below gives a simple example of generating a realization from a univariate Gaussian stationary random
# field at 1600 random locations using the simulate_data_exact function.

library("exageostatr")                                                              # Load ExaGeoStat-R lib.
hardware = list( ncores = 4 , ngpus = 0 , ts = 320 , pgrid = 1 , qgrid = 1 )        # pecifies the required hardware to execute the code. Here, ncores and ngpus are
                                                                                    # the numbers of CPU cores and GPU accelerators to deploy, ts denotes the tile size
                                                                                    # used for parallelized matrix operations, pgrid and qgrid are the cluster topology parameters
                                                                                    # in case of distributed memory system execution.
exageostat_init(hardware)                                                           # Initiate exageostat instance
data.exageo.irreg = simulate_data_exact( kernel = "ugsm-s" ,
    theta = c( 1 , 0.1 , 0.5) , dmetric = "euclidean" , n = 1600 , seed = 0)
exageostat_finalize()                                                               # Finalize exageostat instance


# The following code shows an example of generating a GRF on a [0, 2] × [0, 2] spatial grid with 1600 locations

exageostat_init(hardware)                                                           # Initiate exageostat instance
xy = expand.grid(( 1 : 40 ) / 20 , ( 1 : 40 ) / 20 )
x = xy[ , 1]
y = xy[ , 2]
data.exageo.reg = simulate_obs_exact( x = x , y = y , kernel = "ugsm-s" , theta = c( 1 , 0.1 , 0.5) , dmetric = "euclidean")
exageostat_finalize()                                                               # Finalize exageostat instance


# On the other hand, the simulate_data_exact function can easily generate the GRF within one minute with the following code

n = 25600
hardware = list( ncores = 4 , ngpus = 0 , ts = 320 , pgrid = 1 , pgrid = 1, qgrid = 1 )
exageostat_init(hardware)                                                           # Initiate exageostat instance
data.exageo.reg = simulate_data_exact( kernel = "ugsm-s" , theta = c( 1 , 0.1 , 0.5) , dmetric = "euclidean", n, seed = 0)
exageostat_finalize()                                                               # Finalize exageostat instance
