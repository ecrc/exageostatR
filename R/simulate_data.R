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

#' Simulate Geospatial data (x, y, z)
#' @param sigma_sq A number - variance parameter
#' @param beta A number - smoothness parameter)
#' @param nu A number  - range parameter
#' @param dmetric  A string -  distance metric - "euclidean" or "great_circle"
#' @param n  A number -  data size
#' @param seed  A number -  seed of random generation
#' @return a list of of three vectors (x, y, z)
#' @examples
#' data = simulate_data_exact( sigma_sq, beta, nu, dmetric, seed)
simulate_data_exact <-
  function(sigma_sq,
           beta,
           nu,
           dmetric = c("euclidean", "great_circle"),
           n,
           seed = 0)
  {
	  dmetric = arg_check_sim(sigma_sq, beta, nu, dmetric)
	  assert_that(length(n) == 1)
	  assert_that(n >= 1)
	  assert_that(length(seed) == 1)
    dmetric <- as.integer(dmetric)
    n <- as.integer(n)
    seed <- as.integer(seed)
    globalveclen = as.integer(3 * n)
    globalvec2 = .C("gen_z_exact", sigma_sq, beta, nu, dmetric, n, seed, ncores, ngpus,
      dts, pgrid, qgrid, globalveclen, globalvec = double(globalveclen))$globalvec
    newList <-
      list("x" = globalvec2[1:n],
           "y" = globalvec2[(n + 1):(2 * n)],
           "z" = globalvec2[((2 * n) + 1):(3 * n)])
    
    print("back from gen_z_exact  C function call. Hit key....")
    return(newList)
  }


