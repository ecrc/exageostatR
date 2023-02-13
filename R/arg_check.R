#
#
# Copyright (c) 2017-2023 King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file arg_check.R
# ExaGeoStat R wrapper functions
#
# @version 1.2.0
#
# @author Sameh Abdulah
# @date 2021-10-27

library(assertthat)

#' Check the statistical parameter vector (theta)
#' @param theta:  list of n parameters
#' @return N/A
check_theta <- function (theta)
{
	for (param in theta) {
		assert_that(is.double(param))
		assert_that(length(param) == 1)
		assert_that(param > 0)
	}
}

#' Check the statistical kernel to be in ("ugsm-s", "ugsmn-s",  "bgsfm-s", "bgspm-s", "tgspm-s", "ugsm-st", "bgsm-st")
#' @param kernel: string 
#' @return kernel as integer
check_kernel <- function (kernel)
{
	# kernel=c("ugsm-s", "ugsmn-s",  "bgsfm-s", "bgspm-s", "tgspm-s", "ugsm-st", "bgsm-st")

	if (tolower(kernel) == "ugsm-s")	    # Univariate-Gaussian-stationary-Matern-spatial
		kernel <- 0
	else if (tolower(kernel) == "ugsmn-s")	# Univariate-Gaussian-stationary-Matern-with-nuggets-spatial
		kernel <- 1
	else if (tolower(kernel) == "bgsfm-s")	# Bivariate_matern_flexible
		kernel <- 2
	else if (tolower(kernel) == "bgspm-s")	# Bivariate_matern_parsimonious"
		kernel <- 3
	else if (tolower(kernel) == "tgspm-s")  # Trivariate_matern_parsimonious"
		kernel <- 4
	else if (tolower(kernel) == "ugsm-st")  # Univariate_spacetime_matern_stationary
		kernel <- 5
	else if (tolower(kernel) == "bgsm-st")  # Bivariate_spacetime_matern_stationary
		kernel <- 6    
	else
		stop("Invalid input for kernel")
	return (kernel);
}

#' Check the distance metric input to be "euclidean" or "great_circle"
#' @param dmetric: string
#' @return dmetric as integer
check_dmetric <- function(dmetric) {

	if (length(dmetric) > 1) 
		dmetric <- dmetric[1]
	if (tolower(dmetric) == "euclidean") 
		dmetric <- 0
	else if (tolower(dmetric) == "great_circle") 
		dmetric <- 1
	else 
		stop("Invalid input for dmetric")

	return(dmetric)
}

#' Check the MLE function args
#' @param data A list of x vector (x-dim), y vector (y-dim), and z observation vector
#' @param dmetric  A string -  distance metric - "euclidean" or "great_circle"
#' @param optimization  A list of opt lb values (clb), opt ub values (cub), tol, max_iters
#' @return dmetric as integer
arg_check_mle <- function(data, dmetric, optimization) {

	assert_that(length(data$x) == length(data$y))
	assert_that(length(data$x) == length(data$z))
	assert_that(is.double(data$x))
	assert_that(is.double(data$y))
	assert_that(is.double(data$z))
	assert_that(is.double(optimization$clb))
	assert_that(is.double(optimization$cub))
	assert_that(is.double(optimization$tol))
	assert_that(length(optimization$tol) == 1)
	assert_that(length(optimization$max_iters) == 1)
	assert_that(all(optimization$clb <= optimization$cub))
	assert_that(optimization$tol > 0)
	assert_that(optimization$max_iters >= 1)
	if (length(dmetric) > 1) {
		dmetric <- dmetric[1]
	}
	if (tolower(dmetric) == "euclidean") {
		dmetric <- 0
	} else if (tolower(dmetric) == "great_circle") {
		dmetric <- 1
	} else {
		stop("Invalid input for dmetric")
	}
	return(dmetric)
}

#' Check the prediction function args
#' @param data_train A list of x vector (x-dim), y vector (y-dim), and z observation vector
#' @param data_test A list of x vector (x-dim) and y vector (y-dim)
#' @param theta:  list of n parameters
#' @param dmetric  A string -  distance metric - "euclidean" or "great_circle"
#' @return dmetric as integer
arg_check_predict <- function(data_train, data_test, theta, dmetric) {

	assert_that(length(data_train$x) == length(data_train$y))
	assert_that(length(data_train$x) == length(data_train$z))
	assert_that(length(data_test$x)  == length(data_test$y))
	assert_that(is.double(data_train$x))
	assert_that(is.double(data_train$y))
	assert_that(is.double(data_train$z))
	assert_that(is.double(data_test$x))
	assert_that(is.double(data_test$y))
	
    if (length(dmetric) > 1) {
		dmetric <- dmetric[1]
	}
	if (tolower(dmetric) == "euclidean") {
		dmetric <- 0
	} else if (tolower(dmetric) == "great_circle") {
		dmetric <- 1
	} else {
		stop("Invalid input for dmetric")
	}
	return(dmetric)
}
