#
#
# Copyright (c) 2017, 2018, 2019 King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file exageostat_test_wrapper.R
# ExaGeoStat R wrapper functions
#
# @version 0.1.0
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

#' Simulate Geospatial data given (x, y) locations 
#' @param x A vector  (x-dim)
#' @param y A vector (y-dim)
#' @param sigma_sq A number - variance parameter
#' @param beta A number - smoothness parameter)
#' @param nu A number  - range parameter
#' @param dmetric  A string -  distance metric - "euclidean" or "great_circle"
#' @return a list of of three vectors (x, y, z)
#' @examples
#' data = simulate_obs_exact(x, y, sigma_sq, beta, nu, dmetric)
simulate_obs_exact <-
  function(x, y, sigma_sq, beta, nu, 
           dmetric = c("euclidean", "great_circle"))
  {
	  dmetric = arg_check_sim(sigma_sq, beta, nu, dmetric)
    assert_that(is.double(x))
    assert_that(is.double(y))
    assert_that(length(x) == length(y))
    n = length(x)
    dmetric <- as.integer(dmetric)
    n <- as.integer(n)
    globalveclen = as.integer(3 * n)
    globalvec2 = .C("gen_z_givenlocs_exact", x, n, y, n, sigma_sq, beta, nu, dmetric,
      n, ncores, ngpus, dts, pgrid, qgrid, globalveclen,
      globalvec = double(globalveclen))$globalvec
    newList <- list("x" = x[1:n],
                    "y" = y[1:n],
                    "z" = globalvec2[1:n])
    print("back from gen_z_givenlocs_exact  C function call. Hit key....")
    return(newList)
  }


