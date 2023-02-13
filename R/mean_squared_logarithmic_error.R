#
#
# Copyright (c) 2017-2023 King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
# @file mean_absolute_error.R
#
# @version 1.2.0
#
# @author Faten Alamri 
# @date 2022-01-29
#
#' Mean Absolute Error used as an assessment tool
#' @param y<- c(5:20) - vector representing  number of true values
#' @param ypre<- predict(lm(y ~ x)) - vector denoting values of number of y predicted values
#' @return MSLE is measure of the ratio between the true and predicted values

mean_squared_logarithmic_error <- function(y, ypre){
    MSLE.result = (mean(log(y + 1) - log(ypre + 1)) ^ 2)
    return( MSLE.result)
}
