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

#' Simulate Geospatial data (x, y, z)
#' @param sigma_sq A number - variance parameter
#' @param beta A number - smoothness parameter)
#' @param nu A number  - range parameter
#' @param dmetric  A string -  distance metric - "dm" or "gcd"
#' @param n  A number -  data size
#' @param seed  A number -  seed of random generation
#' @return a list of of three vectors (x, y, z)
#' @examples
#' seed = 0  ##Initial seed to generate XY locs.
#' sigma_sq = 1 ##Initial variance.
#' beta = 0.1 ##Initial smoothness.
#' nu = 0.5 ##Initial range.
#' dmetric = 0 ##0 --> Euclidean distance, 1--> great circle distance.
#' n = 1600 ## The number of locations (n must be a square number, n=m^2).
#' exageostat_init(hardware = list (ncores = 2, ngpus = 0, ts = 320, pgrid  = 1, qgrid  = 1)) ##Initiate exageostat instance
#' data = simulate_data_exact(sigma_sq, beta, nu, dmetric, n, seed) ##Generate Z observation vector
#' data
#' exageostat_finalize() ##Finalize exageostat instance
simulate_data_exact <-
  function(sigma_sq,
           beta,
           nu,
           dmetric = 0,
           n,
           seed = 0)
  {
    globalveclen = 3 * n
    globalvec  = vector (mode = "double", length = globalveclen)
    globalvec2 = .C(
      "gen_z_exact",
      as.double(sigma_sq),
      as.double(beta),
      as.double(nu),
      as.integer(dmetric),
      as.integer(n),
      as.integer(seed),
      as.integer(ncores),
      as.integer(ngpus),
      as.integer(dts),
      as.integer(pgrid),
      as.integer(qgrid),
      as.integer(globalveclen),
      globalvec = double(globalveclen)
    )$globalvec
    
    #               globalvec[1:globalveclen] <- globalvec2[1:globalveclen]
    
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
#' @param dmetric  A string -  distance metric - "dm" or "gcd"
#' @return a list of of three vectors (x, y, z)
#' @examples
#' sigma_sq = 1 ##Initial variance.
#' beta = 0.1 ##Initial smoothness.
#' nu = 0.5 ##Initial range.
#' dmetric = 0 ##0 --> Euclidean distance, 1--> great circle distance.
#' n = 1600 ## The number of locations (n must be a square number, n=m^2)
#' x = rnorm(n, 0, 1)     #x measurements of n locations.
#' y = rnorm(n, 0, 1)    #y measurements of n locations.
#' exageostat_init(hardware = list (ncores = 2, ngpus = 0, ts = 320, pgrid  = 1, qgrid  = 1)) ##Initiate exageostat instance
#' data = simulate_obs_exact(x, y, sigma_sq, beta, nu, dmetric) ##Generate Z observation vector based on given locations
#' data
#' exageostat_finalize() ##Finalize exageostat instance
simulate_obs_exact <-
  function(x, y, sigma_sq, beta, nu, dmetric = 0)
  {
    n = length(x)
    globalveclen = 3 * n
    globalvec  = vector (mode = "double", length = globalveclen)
    globalvec2 = .C(
      "gen_z_givenlocs_exact",
      as.double(x),
      as.integer((n)),
      as.double(y),
      as.integer((n)),
      as.double(sigma_sq),
      as.double(beta),
      as.double(nu),
      as.integer(dmetric),
      as.integer(n),
      as.integer(ncores),
      as.integer(ngpus),
      as.integer(dts),
      as.integer(pgrid),
      as.integer(qgrid),
      as.integer(globalveclen),
      globalvec = double(globalveclen)
    )$globalvec
    #globalvec[1:globalveclen] <- globalvec2[1:globalveclen]
    print(n)
    print(globalveclen)
    
    newList <- list("x" = x[1:n],
                    "y" = y[1:n],
                    "z" = globalvec2[1:n])
    print("back from gen_z_givenlocs_exact  C function call. Hit key....")
    return(newList)
  }


#' Maximum Likelihood Evaluation  using exact method
#' @param data A list of x vector (x-dim), y vector (y-dim), and z observation vector
#' @param dmetric  A string -  distance metric - "dm" or "gcd"
#' @param optimization  A list of opt lb values (clb), opt ub values (cub), tol, max_iters
#' @return vector of three values (theta1, theta2, theta3)
#' @examples
#' seed = 0  ##Initial seed to generate XY locs.
#' sigma_sq = 1 ##Initial variance.
#' beta = 0.1 ##Initial smoothness.
#' nu = 0.5 ##Initial range.
#' dmetric = 0 ##0 --> Euclidean distance, 1--> great circle distance.
#' n = 144 ## The number of locations (n must be a square number, n=m^2).
#' theta_out[1:3] = -1.99 ## Initial outputs
#' exageostat_init(hardware = list (ncores = 2, ngpus = 0, ts = 32, pgrid  = 1, qgrid  = 1)) ##Initiate exageostat instance
#' data = simulate_data_exact(sigma_sq, beta, nu, dmetric, n, seed) ##Generate Z observation vector
#' ##Estimate MLE parameters (Exact)
#' result = exact_mle(data, dmetric, optimization = list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5, 5), tol = 1e-4, max_iters = 1))
#' print(result)
#' exageostat_finalize() ##Finalize exageostat instance
exact_mle <-
  function(data = list (x, y, z),
           dmetric = 0,
           optimization = list(
             clb = c(0.001, 0.001, 0.001),
             cub = c(5, 5, 5),
             tol = 1e-4,
             max_iters = 100
           ))
  {
    n = length(data$x)
    theta_out2 = .C(
      "mle_exact",
      as.double(data$x),
      as.integer((n)),
      as.double(data$y),
      as.integer((n)),
      as.double(data$z),
      as.integer((n)) ,
      as.double(optimization$clb),
      as.integer((3)),
      as.double(optimization$cub),
      as.integer((3)),
      as.integer(dmetric),
      as.integer(n),
      as.double(optimization$tol),
      as.integer(optimization$max_iters),
      as.integer(ncores),
      as.integer(ngpus),
      as.integer(dts),
      as.integer(pgrid),
      as.integer(qgrid),
      theta_out = double(6)
    )$theta_out
    #theta_out[1:6] <- theta_out2[1:6]
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
#' @param dmetric  A string -  distance metric - "dm" or "gcd"
#' @param optimization  A list of opt lb values (clb), opt ub values (cub), tol, max_iters
#' @return vector of three values (theta1, theta2, theta3)
#' @examples
#' seed = 0  ##Initial seed to generate XY locs.
#' sigma_sq = 1 ##Initial variance.
#' beta = 0.03 ##Initial smoothness.
#' nu = 0.5 ##Initial range.
#' dmetric = 0 ##0 --> Euclidean distance, 1--> great circle distance.
#' n = 900 ## The number of locations (n must be a square number, n=m^2).
#' tlr_acc = 7 ##Approximation accuracy 10^-(acc)
#' tlr_maxrank = 150 ##Max Rank
#' exageostat_init(hardware = list (ncores = 2, ngpus = 0, ts = 320, lts = 600, pgrid  = 1, qgrid  = 1)) ##Initiate exageostat instance
#' data = simulate_data_exact(sigma_sq, beta, nu, dmetric, n, seed) ##Generate Z observation vector
#' ##Estimate MLE parameters (TLR approximation)
#' result = tlr_mle(data, tlr_acc, tlr_maxrank, dmetric, optimization = list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5, 5), tol = 1e-4, max_iters = 4))
#' print(result)
#' exageostat_finalize() ##Finalize exageostat instance
tlr_mle <-
  function(data = list (x, y, z),
           tlr_acc = 9,
           tlr_maxrank = 400,
           dmetric = 0,
           optimization = list(
             clb = c(0.001, 0.001, 0.001),
             cub = c(5, 5, 5),
             tol = 1e-4,
             max_iters = 100
           ))
  {
    n = length(data$x)
    theta_out2 = .C(
      "mle_tlr",
      as.double(data$x),
      as.integer((n)),
      as.double(data$y),
      as.integer((n)),
      as.double(data$z),
      as.integer((n)) ,
      as.double(optimization$clb),
      as.integer((3)),
      as.double(optimization$cub),
      as.integer((3)),
      as.integer(tlr_acc),
      as.integer(tlr_maxrank),
      as.integer(dmetric),
      as.integer(n),
      as.double(optimization$tol),
      as.integer(optimization$max_iters),
      as.integer(ncores),
      as.integer(ngpus),
      as.integer(lts),
      as.integer(pgrid),
      as.integer(qgrid),
      theta_out = double(6)
    )$theta_out
    #                               theta_out[1:6] <- theta_out2[1:6]
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
#' @param dmetric  A string -  distance metric - "dm" or "gcd"
#' @param optimization  A list of opt lb (clb), opt ub (cub), tol, max_iters
#' @return vector of three values (theta1, theta2, theta3)
#' @examples
#' seed = 0  ##Initial seed to generate XY locs.
#' sigma_sq = 1 ##Initial variance.
#' beta = 0.03 ##Initial smoothness.
#' nu = 0.5 ##Initial range.
#' dmetric = 0 ##0 --> Euclidean distance, 1--> great circle distance.
#' n = 900 ## The number of locations (n must be a square number, n=m^2).
#' dst_thick = 3 ##Number of used Diagonal Super Tile (DST).
#' exageostat_init(hardware = list (ncores = 4, ngpus = 0, ts = 320, pgrid  = 1, qgrid  = 1)) ##Initiate exageostat instance
#' data = simulate_data_exact(sigma_sq, beta, nu, dmetric, n, seed) ##Generate Z observation vector
#' ##Estimate MLE parameters (TLR approximation)
#' result = dst_mle(data, dst_thick, dmetric, optimization = list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5, 5), tol = 1e-4, max_iters = 4))
#' print(result)
#' exageostat_finalize() ##Finalize exageostat instance
dst_mle <-
  function(data = list (x, y, z),
           dst_thick,
           dmetric = 0,
           optimization = list(
             clb = c(0.001, 0.001, 0.001),
             cub = c(5, 5, 5),
             tol = 1e-4,
             max_iters = 100
           ))
  {
    n = length(data$x)
    theta_out2 = .C(
      "mle_dst",
      as.double(data$x),
      as.integer((n)),
      as.double(data$y),
      as.integer((n)),
      as.double(data$z),
      as.integer((n)) ,
      as.double(optimization$clb),
      as.integer((3)),
      as.double(optimization$cub),
      as.integer((3)),
      as.integer(dst_thick),
      as.integer(dmetric),
      as.integer(n),
      as.double(optimization$tol),
      as.integer(optimization$max_iters),
      as.integer(ncores),
      as.integer(ngpus),
      as.integer(dts),
      as.integer(pgrid),
      as.integer(qgrid),
      theta_out = double(6)
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

#' Initial an instance of ExaGeoStatR
#' @param hardware A list of ncores, ngpus, tile size, pgrid, and qgrid
#' @return N/A
#' @examples
#' exageostat_init(hardware = list (ncores=2,  ngpus=0, ts=320, lts=0, pgrid=1,  qgrid=1 ))
#' exageostat_init(hardware = list (ncores=1,  ngpus=2, ts=320, lts=0, pgrid=1,  qgrid=1 ))
#' exageostat_init(hardware = list (ncores=26, ngpus=0, ts=320, lts=0, pgrid=3,  qgrid=4 ))
exageostat_init <-
  function(hardware = list (
    ncores = 2,
    ngpus = 0,
    ts = 320,
    lts = 0,
    pgrid = 1,
    qgrid = 1
  ))
{

    ncores = 1
    ngpus = 0
    dts = 360
    lts = 600
    pgrid = 1
    qgrid = 1

    ncores <<- hardware$ncores
    ngpus <<- hardware$ngpus
    dts <<- hardware$ts
    lts <<- hardware$lts
    pgrid <<- hardware$pgrid
    qgrid <<- hardware$qgrid
    Sys.setenv(OMP_NUM_THREADS = 1)
    Sys.setenv(STARPU_CALIBRATE = 1)
    Sys.setenv(STARPU_SILENT = 1) 
    Sys.setenv(KMP_AFFINITY = "disabled")   
    .C("rexageostat_init",
       as.integer(ncores),
       as.integer(ngpus),
       as.integer(dts))
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

