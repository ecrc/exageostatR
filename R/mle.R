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

#' Maximum Likelihood Evaluation  using exact method
#' @param data A list of x vector (x-dim), y vector (y-dim), and z observation vector
#' @param dmetric  A string -  distance metric - "euclidean" or "great_circle"
#' @param optimization  A list of opt lb values (clb), opt ub values (cub), tol, max_iters
#' @return vector of three values (theta1, theta2, theta3)
exact_mle <-
  function(data = list (x, y, z),
           dmetric = c("euclidean", "great_circle"),
           optimization = list(
             clb = c(0.001, 0.001, 0.001),
             cub = c(5, 5, 5),
             tol = 1e-4,
             max_iters = 100
           ))
  {
	  dmetric = arg_check_mle(data, dmetric, optimization)
    n = length(data$x)
    dmetric <- as.integer(dmetric)
    n <- as.integer(n)
    optimization$max_iters <- as.integer(optimization$max_iters)
    theta_out2 = .C("mle_exact", data$x, n, data$y, n, data$z, n , optimization$clb, 3,
      optimization$cub, 3, dmetric, n, optimization$tol, optimization$max_iters, ncores,
      ngpus, dts, pgrid, qgrid, theta_out = double(6))$theta_out

    print("back from mle_exact C function call. Hit key....")
    newList <-
      list(
        "sigma_sq" = theta_out2[1],
        "beta" = theta_out2[2],
        "nu" = theta_out2[3],
        "time_per_iter" = theta_out2[4],
        "total_time" = theta_out2[5],
        "no_iters" = theta_out2[6]
      )
    return(newList)
  }


