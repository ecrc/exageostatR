#
#
# Copyright (c) 2017-2023 King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file  test_bm_geor.R 
# ExaGeoStat R wrapper functions
#
# @version 1.2.0
#
# @author Faten Alamri 
# @author Sameh Abdulah
# @date 2022-01-25
#################################################
##                  GeoR
#################################################
library(geoR)                                                                 # Load geoR lib.
library(assertthat)                                                           # Load assertthat lib.
library(exageostatr)                                                          # Load ExaGeoStat-R lib.


####### GeoR 
GeoR_modeling_predicting<-function(Data_train_list, Data_predict_list)        # Modeling & predicting function of GeoR package.
{
    # Estimation step.
    start_time <- Sys.time()                                                  # Timer 
    time <- system.time(
                        # Likelihood Based Parameter Estimation for Gaussian Random Fields.
                        fit_obj <- likfit(coords       = cbind(Data_train_list$x, Data_train_list$y),
                                          data         = Data_train_list$z,
                                          trend        = "cte",
                                          ini.cov.pars = c(0.01,0.01),
                                          fix.nugget   = FALSE,
                                          nugget       = 0,
                                          fix.kappa    = FALSE,
                                          kappa        = 0.6,
                                          cov.model    = "matern",
                                          lik.method   = "ML",
                                          limits       = pars.limits(sigmasq = c(0.01, 5),
                                                                     phi     = c(0.01, 5),
                                                                     kappa   = c(0.01, 5)),
                                          method       = "Nelder-Mead",
                                          control      = list(abstol=1e-5, maxit = 500)))[3]

    theta_out <- c( fit_obj$sigmasq, fit_obj$phi, fit_obj$kappa, fit_obj$tausq) # Estimate theta= sigma^2, beta, nu=smoothing parameter & tau^2= nugget. 


    print(fit_obj$sigmasq)
    print(fit_obj$phi)
    print(fit_obj$kappa)
    print(fit_obj$tausq)
    print(theta_out)
    end_time <- Sys.time()                                                  # Timer end.
    time <- end_time - start_time                                           # Iteration time calculated.
    print(time)

    #Prediction step.
    Data_train <- data.frame(Data_train_list$x, Data_train_list$y,         # Create data frame for location in trainig data.
                             Data_train_list$z)
    Data.gr    <- data.frame(Data_predict_list$x,Data_predict_list$y)      # Create data frame for predicted location.
    Geodata    <- as.geodata(Data_train,coords.col = 1:2, data.col = 3)    # Converts the data to the Class "geodata".
    Data.kc    <- krige.conv(Geodata, locations = Data.gr,                 # Spatial Prediction -- Conventional Kriging
                             krige = krige.control(obj.model = fit_obj))
    z_out      <- Data.kc$predict                                          # Predicted values.

    return(list(theta = theta_out, z_out =    fit_obj$phi,z_out))
}

BM_out <- bm(FUN = GeoR_modeling_predicting, n = 8100,  min_seed = 1, max_seed = 1 ) # Benchmarck Function BM used.
BM_out
