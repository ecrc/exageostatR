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
#' Mean Square Error used as an assessment tool
#' @param y<- c(5:20) - vector representing  number of true values
#' @param ypre<- predict(lm(y ~ x)) - vector denoting values of number of y predicted values.
#' @return MSE is the is the average squares of the “errors”

mean_square_error <- function(y, ypre){
	mse.result = (mean(y - ypre) ^ 2)
	return (mse.result)

}
