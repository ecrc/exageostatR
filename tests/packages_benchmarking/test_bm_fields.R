#
#
# Copyright (c) 2017-2023 King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file test_bm_fields.R  
# ExaGeoStat R wrapper functions
#
# @version 1.2.0
#
# @author Faten Alamri
# @author Sameh Abdulah
# @date 2021-10-27

#################################################
##                  fields
#################################################
library(assertthat)                                                          # Load assertthat lib.
library(exageostatr)                                                         # Load ExaGeoStat-R lib.
library(spam)                                                                # Load spam lib.
library(dotCall64)                                                           # Load dotCall64 lib.
library(grid)                                                                # Load grid lib.
library(fields)                                                              # Load fields lib.
library(sp)                                                                  # Load sp  lib.


############ fields 
Fields_modeling_predicting<-function(Data_train_list, Data_predict_list)     # Modeling & predicting function of package Fields.
{
    start_time <- Sys.time()                                                 # Timer
    s <- cbind(Data_train_list$x, Data_train_list$y)                         # s is a vector of x & y (location) of the training data.
    s_test <- cbind(Data_predict_list$x, Data_predict_list$y)                # s_test is x & y vector (prediction/testing location) of the testing data.
    z <- Data_train_list$z                                                   # z is the list of measured value at the training data. 
    obj <- spatialProcess(s, z, cov.args = list(Covariance = "Matern",       # Estimates a spatial process model.
                                                smoothness = 0.6), reltol = 1e-7)
    predict_test<- predict( obj, s_test)                                     # Model Predictions
    theta_out <-c( obj$MLESummary[[7]],obj$MLESummary[[8]],                  # Predicted parameters.  
                  obj$args$smoothness, (obj$MLESummary[[6]])^2) 
    print(theta_out) 
    end_time <- Sys.time()                                                   # Timer end.
    time <- end_time - start_time                                            # Iteration time calculated.
    print(time)
    return(list(theta = theta_out, z_out =   predict_test))
}

BM_out <- bm(FUN = Fields_modeling_predicting, n = 8100,                    # Benchmarck Function BM used.
             min_seed = 1, max_seed = 1)
BM_out 
