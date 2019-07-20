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
# @version 1.0.0
#
# @author Sameh Abdulah
# @date 2019-01-17
Test1 <- function()
  # Test Generating Z vector using random (x, y) locations with exact MLE computation.
{
  library("exageostat")                                           #Load ExaGeoStat-R lib.
  seed            = 0                                             #Initial seed to generate XY locs.
  sigma_sq        = 1                                             #Initial variance.
  beta            = 0.1                                           #Initial smoothness.
  nu              = 0.5                                           #Initial range.
  dmetric         = 0                                             #0 --> Euclidean distance, 1--> great circle distance.
  n               = 1600                                          #n*n locations grid.
  #theta_out[1:3]                  = -1.99
  exageostat_init(hardware = list (
    ncores = 2,
    ngpus  = 0,
    ts     = 320,
    pgrid  = 1,
    qgrid  = 1
  ))#Initiate exageostat instance
  #Generate Z observation vector
  data      = simulate_data_exact(sigma_sq, beta, nu, dmetric, n, seed) #Generate Z observation vector
  #Estimate MLE parameters (Exact)
  result          = exact_mle(data,
                            dmetric,
                            optimization = list(
                              clb = c(0.001, 0.001, 0.001),
                              cub = c(5, 5, 5),
                              tol = 1e-4,
                              max_iters = 20
                            ))
  
  #print(result)
  #Finalize exageostat instance
  exageostat_finalize()
  browser()
}


Test2 <- function()
  # Test Generating Z vector using random (x, y) locations with TLR MLE computation.
{
  library("exageostat")                                           #Load ExaGeoStat-R lib.
  seed            = 0                                             #Initial seed to generate XY locs.
  sigma_sq        = 1                                             #Initial variance.
  beta            = 0.03                                          #Initial smoothness.
  nu              = 0.5                                           #Initial range.
  dmetric         = 0                                             #0 --> Euclidean distance, 1--> great circle distance.
  n               = 900                                           #n*n locations grid.
  tlr_acc         = 7                                             #Approximation accuracy 10^-(acc)
  tlr_maxrank     = 450                                           #Max Rank
  
  #Initiate exageostat instance
  exageostat_init(hardware = list (
    ncores = 2,
    ngpus  = 0,
    ts     = 320,
    lts    = 600,
    pgrid  = 1,
    qgrid  = 1
  ))#Initiate exageostat instance
  #Generate Z observation vector
  data      = simulate_data_exact(sigma_sq, beta, nu, dmetric, n, seed) #Generate Z observation vecto
  #Estimate MLE parameters (TLR approximation)
  result       = tlr_mle(
    data,
    tlr_acc,
    tlr_maxrank,
    dmetric,
    optimization = list(
      clb = c(0.001, 0.001, 0.001),
      cub = c(5, 5, 5),
      tol = 1e-4,
      max_iters = 20
    )
  )
  #print(result)
  #Finalize exageostat instance
  exageostat_finalize()
  browser()
}

Test3 <- function()
  # Test Generating Z vector using random (x, y) locations with DST MLE computation.
{
  library("exageostat")                                           #Load ExaGeoStat-R lib.
  seed            = 0                                             #Initial seed to generate XY locs.
  sigma_sq        = 1                                             #Initial variance.
  beta            = 0.03                                          #Initial smoothness.
  nu              = 0.5                                           #Initial range.
  dmetric         = 0                                             #0 --> Euclidean distance, 1--> great circle distance.
  n               = 900                                           #n*n locations grid.
  dst_thick       = 3                                             #Number of used Diagonal Super Tile (DST).
  #Initiate exageostat instance
  exageostat_init(hardware = list (
    ncores = 4,
    ngpus  = 0,
    ts     = 320,
    lts    = 0,
    pgrid  = 1,
    qgrid  = 1
  ))
  #Generate Z observation vector
  data      = simulate_data_exact(sigma_sq, beta, nu, dmetric, n, seed) #Generate Z observation vecto
  #Estimate MLE parameters (DST approximation)
  result       = dst_mle(data,
                         dst_thick,
                         dmetric,
                         optimization = list(
                           clb = c(0.001, 0.001, 0.001),
                           cub = c(5, 5, 5),
                           tol = 1e-4,
                           max_iters = 20
                         ))
  #print(result)
  #Finalize exageostat instance
  exageostat_finalize()
  browser()
}


Test4 <- function()
  # Test Generating Z vector using given (x, y) locations with exact MLE computation.
{
  library("exageostat")                                                   #Load ExaGeoStat-R lib.
  sigma_sq        = 1                                                     #Initial variance.
  beta            = 0.1                                                   #Initial smoothness.
  nu              = 0.5                                                   #Initial range.
  dmetric         = 0                                                     #0 --> Euclidean distance, 1--> great circle distance.
  n               = 1600                                                  #n*n locations grid.
  x               = rnorm(n = 1600, mean = 39.74, sd = 25.09)     #x measurements of n locations.
  y               = rnorm(n = 1600, mean = 80.45, sd = 100.19)    #y measurements of n locations.
  #Initiate exageostat instance
  exageostat_init(hardware = list (
    ncores = 2,
    ngpus  = 0,
    ts     = 320,
    lts    = 0,
    pgrid  = 1,
    qgrid  = 1
  ))#Initiate exageostat instance
  #Generate Z observation vector based on given locations
  data          = simulate_obs_exact(x, y, sigma_sq, beta, nu, dmetric)
  #Estimate MLE parameters (Exact)
  result        = exact_mle(data,
                            dmetric,
                            optimization = list(
                              clb = c(0.001, 0.001, 0.001),
                              cub = c(5, 5, 5),
                              tol = 1e-4,
                              max_iters = 20
                            ))
  #print(result)
  #Finalize exageostat instance
  exageostat_finalize()
  browser()
}

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


exageostat_init <-
  function(hardware = list (
    ncores = 2,
    ngpus = 0,
    ts = 320,
    lts = 0,
    pgrid = 1,
    qgrid = 1
  ),
  globalveclen)
  {
    ncores <<- hardware$ncores
    ngpus <<- hardware$ngpus
    dts <<- hardware$ts
    lts <<- hardware$lts
    pgrid <<- hardware$pgrid
    qgrid <<- hardware$qgrid
    #library(parallel)
    #        library(foreach)
    #        library(doParallel)
    #       machineVec <- c(rep("nid00816",4), rep("nid00817",4), rep("nid00818",4), rep("nid00819",4))
    #       c1<<-makeCluster(machineVec, port=22222)
    #        registerDoParallel(c1)
    #        getDoParWorkers()
    #       x = detectCores()
    #       print(x)
    Sys.setenv(OMP_NUM_THREADS = 1)
    #Sys.setenv(STARPU_WORKERS_NOBIND = 1)
    Sys.setenv(STARPU_CALIBRATE = 1)
    #Sys.setenv(STARPU_SCHED = "eager")
    Sys.setenv(STARPU_SILENT = 1) 
    Sys.setenv(KMP_AFFINITY = "disabled")   
    #mcaffinity(1:hardware$ncores)
    
    .C("rexageostat_init",
       as.integer(ncores),
       as.integer(ngpus),
       as.integer(dts))
    print("back from exageostat_init C function call. Hit key....")
  }

exageostat_finalize <- function()
{
  .C("rexageostat_finalize")
  print("back from exageostat_finalize C function call. Hit key....")
}

