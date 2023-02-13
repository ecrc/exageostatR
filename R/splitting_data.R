#
#
# Copyright (c) 2017-2023 King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file simulate_data_xy.R
# ExaGeoStat R wrapper functions
#
# @version 1.2.0
#
# @author Faten Alamri 
# @author Sameh Abdulah
# @date 2021-12-20

library(assertthat)

#' Spliting data into training and testing datasets
#' @param Datatray: the full dataset
#' @param k: testing dataset portion k\%
#' @param n: number of spatial locations
#' @return a list of training and testing datasets


splitting_data <- function( Datatray, k = 10 , n=400 ){
    unit<- 100-k 
    unit<-unit/100
    k<-k/100
    x <- Datatray["x"]
    y <- Datatray["y"]
    z <- Datatray["z"]
    Datatray <- data.frame(x, y, z)
    ind <- sample(c(TRUE, FALSE), n, replace = TRUE, prob = c(0.90, 0.10))
    training <- Datatray[ind, , ]
    testing  <- Datatray[!ind, , ]
    x_train  <- training [, 1]
    y_train  <- training [, 2]
    z_train  <- training[, 3]
    x_test   <- testing [, 1]
    y_test   <- testing [, 2]
    z_test   <- testing[, 3]
    data_train = cbind(x_train, y_train, z_train)
    data_test  = cbind(x_test, y_test, z_test)
    return(list(train = data_train, test = data_test))
}
