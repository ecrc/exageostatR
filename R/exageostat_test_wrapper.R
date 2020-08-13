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


#' Maximum Likelihood Evaluation (MLE) using Tile Low-Rank (TLR) method
#' @param data A list of x vector (x-dim), y vector (y-dim), and z observation vector
#' @param tlr_acc  A number - TLR accuracy level
#' @param tlr_maxrank  A string -  TLR max rank
#' @param dmetric  A string -  distance metric - "euclidean" or "great_circle"
#' @param optimization  A list of opt lb values (clb), opt ub values (cub), tol, max_iters
#' @return vector of three values (theta1, theta2, theta3)
tlr_mle <-
  function(data = list (x, y, z),
           tlr_acc = 9,
           tlr_maxrank = 400,
           dmetric = c("euclidean", "great_circle"),
           optimization = list(
             clb = c(0.001, 0.001, 0.001),
             cub = c(5, 5, 5),
             tol = 1e-4,
             max_iters = 100
           ))
  {
	  dmetric = arg_check_mle(data, dmetric, optimization)
	  assert_that(length(tlr_acc) == 1)
	  assert_that(length(tlr_maxrank) == 1)
	  assert_that(tlr_acc > 0)
	  assert_that(tlr_maxrank >= 1)
    n <- length(data$x)
    dmetric <- as.integer(dmetric)
    n <- as.integer(n)
    tlr_acc <- as.integer(tlr_acc)
    tlr_maxrank <- as.integer(tlr_maxrank)
    optimization$max_iters <- as.integer(optimization$max_iters)
    theta_out2 = .C("mle_tlr", data$x, n, data$y, n, data$z, n , optimization$clb, 3,
      optimization$cub, 3, tlr_acc, tlr_maxrank, dmetric, n, optimization$tol,
      optimization$max_iters, ncores, ngpus, lts, pgrid, qgrid, theta_out = double(6)
    )$theta_out
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

#' Maximum Likelihood Evaluation (MLE) using Diagonal Super-tile (DST) method
#' @param data A list of x vector (x-dim), y vector (y-dim), and z observation vector
#' @param dst_thick  A number - Diagonal Super-Tile (DST) diagonal thick
#' @param dmetric  A string -  distance metric - "euclidean" or "great_circle"
#' @param optimization  A list of opt lb (clb), opt ub (cub), tol, max_iters
#' @return vector of three values (theta1, theta2, theta3)
dst_mle <-
  function(data = list (x, y, z),
           dst_thick,
           dmetric = c("euclidean", "great_circle"),
           optimization = list(
             clb = c(0.001, 0.001, 0.001),
             cub = c(5, 5, 5),
             tol = 1e-4,
             max_iters = 100
           ))
  {
	  dmetric = arg_check_mle(data, dmetric, optimization)
	  assert_that(length(dst_thick) == 1)
	  assert_that(dst_thick >= 1)
    n <- length(data$x)
    dmetric <- as.integer(dmetric)
    n <- as.integer(n)
    dst_thick <- as.integer(dst_thick)
    optimization$max_iters <- as.integer(optimization$max_iters)
    theta_out2 = .C("mle_dst", data$x, n, data$y, n, data$z, n , optimization$clb, 3,
      optimization$cub, 3, dst_thick, dmetric, n, optimization$tol, optimization$max_iters,
      ncores, ngpus, dts, pgrid, qgrid, theta_out = double(6))$theta_out
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

#' Initial an instance of ExaGeoStatR
#' @param hardware A list of ncores, ngpus, tile size, pgrid, and qgrid
#' @return N/A
#' @examples
#' exageostat_init(hardware = list (ncores=2,  ngpus=0, ts=320, lts=0, pgrid=1,  qgrid=1 ))
#' exageostat_init(hardware = list (ncores=1,  ngpus=2, ts=320, lts=0, pgrid=1,  qgrid=1 ))
#' exageostat_init(hardware = list (ncores=26, ngpus=0, ts=320, lts=0, pgrid=3,  qgrid=4 ))
exageostat_init <-
  function(hardware = list(ncores = 2, ngpus = 0, ts = 320, lts = 0, pgrid = 1, qgrid = 1))
{
    ncores <- hardware$ncores
    ngpus <- hardware$ngpus
    dts <- hardware$ts
    lts <- hardware$lts
    pgrid <- hardware$pgrid
    qgrid <- hardware$qgrid

    ncores <- as.integer(ncores)
    ngpus <- as.integer(ngpus)
    dts <- as.integer(dts)
    lts <- as.integer(lts)
    pgrid <- as.integer(pgrid)
    qgrid <- as.integer(qgrid)

    assert_that(ncores > 0)
    assert_that(ngpus > 0)
    assert_that(dts > 0)
    assert_that(lts >= 0)
    assert_that(pgrid > 0)
    assert_that(qgrid > 0)

    Sys.setenv(OMP_NUM_THREADS = 1)
    Sys.setenv(STARPU_CALIBRATE = 1)
    Sys.setenv(STARPU_SILENT = 1) 
    Sys.setenv(KMP_AFFINITY = "disabled")   
    .C("rexageostat_init", ncores, ngpus, dts)
    print("back from exageostat_init C function call. Hit key....")
}

#' Finalize the current instance of ExaGeoStatR
#' @return N/A
#' @examples
#' exageostat_finalize()
exageostat_finalize <- function()
{
  .C("rexageostat_finalize")
  print("back from exageostat_finalize C function call. Hit key....")
}

arg_check_sim <- function(sigma_sq, beta, nu, dmetric)
{
	assert_that(is.double(sigma_sq))
	assert_that(is.double(beta))
	assert_that(is.double(nu))
	assert_that(length(sigma_sq) == 1)
	assert_that(length(beta) == 1)
	assert_that(length(nu) == 1)
	assert_that(sigma_sq > 0)
	assert_that(beta > 0)
	assert_that(nu > 0)
	if(length(dmetric) > 1)
            dmetric = dmetric[1]
        if(tolower(dmetric) == "euclidean")
            dmetric = 0
        else if(tolower(dmetric) == "great_circle")
            dmetric = 1
        else
            stop("Invalid input for dmetric")
	return dmetric
}

arg_check_mle <- function(data, dmetric, optimization)
{
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
	if(length(dmetric) > 1)
            dmetric = dmetric[1]
        if(tolower(dmetric) == "euclidean")
            dmetric = 0
        else if(tolower(dmetric) == "great_circle")
            dmetric = 1
        else
            stop("Invalid input for dmetric")
	return dmetric
}
