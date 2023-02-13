#
#
# Copyright (c) 2017-2023 King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
# @file exact_mloe_mmom.R
# ExaGeoStat R wrapper functions
#
# @version 1.2.0
#
# @author Faten Alamri 
# @author Sameh Abdulah
# @date 2021-12-23

library(assertthat)

#' Mean Misspecification of the Mean Square Error (MMOM) and Mean Loss of Efficiency (MLOE) using exact method
#' @param data: list of training and testing vectors
#' @param kernel: string - kernel  ("ugsm-s", "ugsmn-s",  "bgsfm-s", "bgspm-s", "tgspm-s", "ugsm-st", "bgsm-st")
#' @param dmetric  string -  distance metric - "euclidean" or "great_circle"
#' @param est_theta:  list of n parameters (estimated theta)
#' @param true_theta:  list of n parameters (true theta)
#' @param computation: integer -  should be always dense
#' @return vector of MLOE/MMOM values

exact_mloe_mmom <-
    function( 
             data = list(x_train, y_train, z_train, x_test, y_test),
             kernel=c("ugsm-s", "ugsmn-s", "ugnsm-s", "bgsfm-s", "bgsbm-s", "ugsm-s", "ugsm-st"),
             dmetric = c("euclidean", "great_circle"), est_theta, true_theta,   computation=0) # Obs = train, miss=test
    {
        if (!exists("active_instance") || active_instance == 0) {
            print("No active ExaGeoStatR instance.")
        }
        else {
            data_train = list(x=data$x_train, y=data$y_train, z=data$z_train)
            data_test = list(x=data$x_test, y=data$y_test)
            dmetric  <- arg_check_predict(data_train, data_test, theta, dmetric) # Check function the argument is correct
            kernel   <- check_kernel(kernel)
            n_train  <- length(data$x_train)
            n_test   <- length(data$x_test)
            thetalen <- length(theta)
            print("mloe/mmom calculations.....\n")
            globalmloe_mmom2 <- .C(
                                "exact_mloe_mmom",
                                as.double(data$x_train),
                                as.integer((n_train)),
                                as.double(data$y_train),
                                as.integer((n_train)),
                                as.double(data$z_train),
                                as.integer((n_train)),
                                as.double(data$x_test),
                                as.integer((n_test)),
                                as.double(data$y_test),
                                as.integer((n_test)),
                                as.integer((n_train)),
                                as.integer((n_test)),
                                as.integer(kernel),
                                as.double(est_theta),
                                as.double(true_theta),
                                as.integer(thetalen),
                                as.integer(dmetric),
                                as.integer(ncores),
                                as.integer(ngpus),
                                as.integer(dts),
                                as.integer(pgrid),
                                as.integer(qgrid), 
                                globalmloe_mmom = double(n_test)
                                )$globalmloe_mmom

            print("back from mloe_mmom.")
            mloe_mmom_values = globalmloe_mmom2

            return(mloe_mmom_values)
        }
    }
