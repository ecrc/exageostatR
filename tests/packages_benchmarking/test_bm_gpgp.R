#
# Copyright (c) 2017-2023 King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file test_bm_gpgp.R
# ExaGeoStat R wrapper functions
#
# @version 1.2.0
#
# @author Faten Alamri 
# @author Sameh Abdulah
# @date 2022-01-25
#################################################
##                  GPGP
#################################################
library(exageostatr)                                                       # Load ExaGeoStat-R lib.
library(GpGp)                                                              # Load GpGp lib.

####### GpGp
GpGp_modeling_predicting<-function(Data_train_list, Data_predict_list)     # Modeling & prediction function of package GpGp. 
{

    start_time <- Sys.time()                                          # Timer.
    # Modeling
    y <- as.matrix (Data_train_list$z)                                # Vector y of the object in training data.
    print(y)
    locs <- cbind(Data_train_list$x, Data_train_list$y)               # Vector of locations  in training data.
    n1 <- nrow(y)
    X <- as.matrix( rep(1, n1) )
    fit <- fit_model(y, locs, X, "matern_isotropic",                  # Estimate Parameters of (Mixture) Hidden Markov Models and Their Restricted Variants.
                     NNarray = NULL,
                     start_parms = c(0.01,0.01,0.01,0.01),
                     reorder = TRUE,
                     group = TRUE,
                     #m_seq = c(309),
                     max_iter = 1000,
                     fixed_parms = NULL,
                     silent = FALSE,
                     st_scale = NULL,
                     convtol = 1e-7
                     )
    summary(fit)

    # Predicting. 
    locs_pred<- cbind(Data_predict_list$x,Data_predict_list$y)      # Vector of locations of interest.
    ntest=length(Data_predict_list$x)                               # Length of location x vector. 
    X_pred <- as.matrix( rep(1, ntest) )

    pred<-predictions(                                              # Compute Gaussian process predictions using Vecchia's approximations.
                      fit, locs_pred,
                      X_pred,
                      y_obs = fit$y, locs_obs = fit$locs, X_obs = fit$X,
                      beta = fit$betahat,
                      covparms = fit$covparms, covfun_name = fit$covfun_name, m = 60,
                      reorder = FALSE,
                      st_scale = NULL
                      )

    theta_out <- c( fit$covparms[1], fit$covparms[2],               # Predicted parameters. 
                 fit$covparms[3],(fit$covparms[4]/fit$covparms[1]))

    end_time <- Sys.time()
    time <- end_time - start_time                                   # Iteration time calculated. 
    print(time)
    return(list(theta = theta_out, z_out =    pred))


}

BM_out <- bm(FUN = GpGp_modeling_predicting, n = 8100,             # Benchmarck Function BM used.
           min_seed = 1, max_seed = 50)
BM_out

