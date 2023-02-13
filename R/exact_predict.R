#
#
# Copyright (c) 2017-2023 King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file exact_predict.R
# ExaGeoStat R wrapper functions
#
# @version 1.2.0
#
# @author Faten Alamri 
# @author Sameh Abdulah
# @date 2021-12-27

# TODO
# Conventional kriging methods  
# Simple Kriging 
# Ordinary kriging 
# External trend kriging 
# Universal kriging 

#' Perform prediction on testing data using training data and pre-estimated theta vector
#' @param data_train: list of training data 
#' @param data_test: list of testing data
#' @param kernel: string - kernel  ("ugsm-s", "ugsmn-s",  "bgsfm-s", "bgspm-s", "tgspm-s", "ugsm-st", "bgsm-st")
#' @param dmetric  string -  distance metric - "euclidean" or "great_circle"
#' @param theta:  list of n parameters (estimated theta)
#' @param computation: integer -  computation method
#' @return list of predicted values
exact_predict <-
    function(data_train = list(x, y, z), data_test = list (x, y),
             kernel = c("ugsm-s", "ugsmn-s", "ugnsm-s", "bgsfm-s", "bgsbm-s", "ugsm-s", "ugsm-st"),
             dmetric = c("euclidean", "great_circle"), theta, computation = 0) 
    {
        if (!exists("active_instance") || active_instance == 0) {
            print("No active ExaGeoStatR instance.")
        }
        else {

            dmetric  <- arg_check_predict(data_train, data_test, theta, dmetric) #checking function the argument is correct
            kernel   <- check_kernel(kernel)
            n_train  <- length(data_train$x)
            n_test   <- length(data_test$x)
            thetalen <- length(theta)
            globalz_test2 <- .C(
                                "exact_predict",
                                as.double(data_train$x),
                                as.integer((n_train)),
                                as.double(data_train$y),
                                as.integer((n_train)),
                                as.double(data_train$z),
                                as.integer((n_train)),
                                as.double(data_test$x),
                                as.integer((n_test)),
                                as.double(data_test$y),
                                as.integer((n_test)),
                                as.integer((n_train)),
                                as.integer((n_test)),
                                as.integer(kernel),
                                as.double(theta),
                                as.integer(thetalen),
                                as.integer(computation),
                                as.integer(dmetric),
                                as.integer(ncores),
                                as.integer(ngpus),
                                as.integer(dts),
                                as.integer(pgrid),
                                as.integer(qgrid),
                                globalz_test = double(n_test)
                                )$globalz_test

            print("back from mle_predict.")

            predicted_values = globalz_test2


            return(predicted_values)
        }
    }
