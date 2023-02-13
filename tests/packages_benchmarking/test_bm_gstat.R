#
#
# Copyright (c) 2017-2023 King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file test_bm_gstat.R
# ExaGeoStat R wrapper functions
#
# @version 1.2.0
#
# @author Faten Alamri 
# @author Sameh Abdulah
# @date 2022-10-25
#################################################
##                  Gstat
#################################################
library(geoR)                                                                 # Load geoR lib.
library(assertthat)                                                           # Load assertthat lib.
library(exageostatr)                                                          # Load exageostatr lib.
library(gstat)                                                                # Load gstat lib.
library(sp)                                                                   # Load sp lib.


####### Gstat
Gstat_modeling_predicting <- function(Data_train_list, Data_predict_list)     # Gstat function of modeling & prediction.
{
    start_time <- Sys.time()                                              # Timer.
    Data_train_list=as.data.frame(Data_train_list)                        # Coerce trining data list to a Data Frame.
    coordinates(Data_train_list)  = ~ x + y                               # Setting coordinate.
    Data_predict_list=as.data.frame(Data_predict_list)                    # Coerce predicting data list to a Data Frame.
    coordinates(Data_predict_list) = ~ x + y
    value <- list (Data_train_list$z)                                     # List of objecties at training data. 
    locations <- list(c(Data_train_list$x, Data_train_list$y))            # List of locations at training data. 
    vrg <- variogram(value, locations)                                    # Calculate Sample or Residual Variogram or Variogram Cloud. 

    # modeling
    print("Data modeling...........")
    vrg.fit = fit.variogram(vrg, model = vgm(psill = 0.1, model = "Mat",      # Fit a Variogram Model to a Sample Variogram.
                                             range = 0.1,  kappa = 0.1) , fit.kappa = TRUE)
    vrg.fit

    print("Data Predicting...........")
    vrg.krige = krige(z~1,Data_train_list, Data_predict_list,             # Simple kriging.
                      model = vrg.fit)

    # Prediction
    dta1 <- as.data.frame(cbind(Data_train_list$x,Data_train_list$y,      # Coerce predicting data list to a Data Frame.
                                Data_train_list$z))
    kcv <-krige.cv(z~1, Data_train_list, dta1, model = vrg.fit,           # Kriging cross validation.
                   verbose = TRUE, nmax = 30)

    theta_out <- c(vrg.fit[1,]$psill, vrg.fit[1,]$range,                  # Estimate theta = sigma^2, beta, nu=smoothing parameter. 
                   vrg.fit[1,]$kappa,  0)

    print(theta_out)  
    end_time <- Sys.time()                                                # End timer.
    time <- end_time - start_time                                         # Iteration time calculated. 
    print(time)
    return( list(theta=theta_out, z_out = kcv$var1.pred )) 

}

BM_out <- bm(FUN = Gstat_modeling_predicting, n = 8100,                   # Benchmarck Function BM used.
             min_seed = 1, max_seed = 1, ncores = 20)
BM_out

