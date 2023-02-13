#
#
# Copyright (c) 2017-2023 King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file test_bm_exageostatr_tlr7.R
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
library(assertthat)                                                                  # Load assertthat lib.
library(exageostatr)                                                                 # Load ExaGeoStat-R lib.
library(MASS)                                                                        # Load MASS lib.


####### ExaGeoStatR_tlr7

exageostat_tlr7_modeling_predicting<-function(Data_train_list, Data_predict_list)   # Function of exageostat at tile low rank=7 modeling & predicting.
{
    dmetric = "euclidean"                                                       # 0 --> Euclidean distance, 1--> great circle distance.
    tlr_acc = 7                                                                 # Approximation accuracy 10^-(acc)
    tlr_maxrank = 400                                                           # Tile low rank Max Rank
    exageostat_init(hardware = list (ncores = 27 , ngpus = 0, ts = 320, 
                                     lts = 400 , pgrid = 1, qgrid = 1))         # Initiate exageostat instance.

    result_mle <- tlr_mle(Data_train_list, "ugsm-s", tlr_acc, tlr_maxrank,      # Estimate MLE parameters with tile low rank method.
                          dmetric, optimization = list(clb = c(0.01, 0.01, 0.01), cub = c(2, 2, 2),
                                                       tol = 1e-7, max_iters = 4000))        

    est_theta <- c(result_mle  ["sigma_sq"], result_mle  ["beta"],              # Estimate theta= sigma^2, beta, nu=smoothing parameter.
                   result_mle  ["nu"])


    prediction_result <- exact_predict(Data_train_list, Data_predict_list,      # Predict on training data.
                                       "ugsm-s", dmetric, est_theta, 0)

    theta_out <- c(result_mle$sigma, result_mle$beta, result_mle$nu, 0)         # Predicted parameters.

    exageostat_finalize()                                                       # Finalize exageostat instance.
    return(list(theta = theta_out, z_out = prediction_result))

}

BM_out <- bm(FUN = exageostat_tlr7_modeling_predicting,  n = 8100,              # Benchmarck Function BM used.
             min_seed = 1, max_seed = 50, ncores = 27)
BM_out
