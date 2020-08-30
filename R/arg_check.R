#
#
# Copyright (c) 2017-2020 King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file exageostat_test_wrapper.R
# ExaGeoStat R wrapper functions
#
# @version 1.0.1
#
# @author Sameh Abdulah
# @date 2019-09-25

library(assertthat)

utils::globalVariables(c("ncores"))
utils::globalVariables(c("ngpus"))
utils::globalVariables(c("dts"))
utils::globalVariables(c("lts"))
utils::globalVariables(c("pgrid"))
utils::globalVariables(c("qgrid"))
utils::globalVariables(c("x"))
utils::globalVariables(c("y"))
utils::globalVariables(c("z"))

arg_check_sim <- function(sigma_sq, beta, nu, dmetric) {
  assert_that(is.double(sigma_sq))
  assert_that(is.double(beta))
  assert_that(is.double(nu))
  assert_that(length(sigma_sq) == 1)
  assert_that(length(beta) == 1)
  assert_that(length(nu) == 1)
  assert_that(sigma_sq > 0)
  assert_that(beta > 0)
  assert_that(nu > 0)
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

arg_check_mle <- function(data, dmetric, optimization) {
  assert_that(length(data$x) == length(data$y))
  assert_that(length(data$x) == length(data$z))
  assert_that(is.double(data$x))
  assert_that(is.double(data$y))
  assert_that(is.double(data$z))
  assert_that(is.double(optimization$clb))
  assert_that(is.double(optimization$cub))
  assert_that(is.double(optimization$tol))
  assert_that(length(optimization$clb) == 3)
  assert_that(length(optimization$cub) == 3)
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
