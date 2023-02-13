#
#
# Copyright (c) 2017-2023 King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file test_bm_exageostatr.R
# ExaGeoStat R wrapper functions
#
# @version 1.2.0
#
# @author Faten Alamri 
# @author Sameh Abdulah
# @date 2022-1-25

#################################################
##                 ExaGeoStatR
#################################################
library(assertthat)                                                             # Load assertthat lib.
library(exageostatr)                                                            # Load ExaGeoStat-R lib.
library(MASS)                                                                   # Load MASS lib.

####### ExaGeoStatR
Exageostat_modeling_predicting <- function(Data_train_list, Data_predict_list) # Function of Exageostat_modeling_predicting
{
    start_time <- Sys.time()

    dmetric = "euclidean"
    exageostat_init(hardware = list (ncores = 38 , ngpus = 0,                  # Initiate exageostat instance.
                                     ts = 320, lts = 0 , pgrid = 1, qgrid = 1)) 


    result_mle  = exact_mle(Data_train_list,"ugsm-s", dmetric,                 # Estimate MLE parameters with tile low rank method.
                            optimization = list(clb = c(0.001, 0.001, 0.001),
                                                cub = c(5, 5,5 ), tol = 1e-7, max_iters = 4000))

    est_theta <- c(result_mle  ["sigma_sq"], result_mle  ["beta"],             # Estimate theta= sigma^2, beta, nu=smoothing parameter.
                   result_mle  ["nu"])


    prediction_result <- exact_predict(Data_train_list, Data_predict_list,     # Predict on training data (missing/ omitted data). 
                                       "ugsm-s",  dmetric, est_theta, 0)

    theta_out = c(result_mle$sigma, result_mle$beta,                           # Predicted parameters. 
                  result_mle$nu, 0)

    exageostat_finalize()                                                      # Finalize exageostat instance.

    end_time <- Sys.time()
    time <- end_time - start_time
    print(time)
    return(list(theta = theta_out, z_out = prediction_result))

}


BM_out <- bm(FUN = Exageostat_modeling_predicting,  n = 8100,                  # Benchmarck Function BM used.
             min_seed = 1, max_seed = 1, ncores = 1)
BM_out
