 #
 #
 # Copyright (c) 2017, King Abdullah University of Science and Technology
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
 # @date 2017-11-14
 
  
TestWrapper <- function()
{
	library("exageostat")                                   #Load ExaGeoStat-R lib.
	theta1          = 1                                     #Initial variance.
	theta2          = 0.1                                   #Initial smoothness.
	theta3          = 0.5                                   #Initial range.
	computation     = 0                                     #0 --> exact computation, 1--> LR approx. computation.
	dmetric         = 0                                     #0 --> Euclidean distance, 1--> great circle distance.
	n               = 1600                                  #n*n locations grid.
	ncores          = 2                                     #Number of underlying CPUs.
	gpus            = 0                                     #Number of underlying GPUs.
	ts              = 320                                   #Tile_size:  changing it can improve the performance. No fixed value can be given.
	p_grid          = 1                                     #More than 1 in the case of distributed systems
	q_grid          = 1                                     #More than 1 in the case of distributed systems ( usually equals to p_grid)
	clb             = vector(mode="numeric",length = 3)     #Optimization function lower bounds values.
	cub             = vector(mode="numeric",length = 3)     #Optimization function upper bounds values.
	theta_out       = vector(mode="numeric",length = 3)     #Parameter vector output.
	globalveclen    = 3*n
	vecs_out        = vector(mode="numeric",length = globalveclen)     #Z measurements of n locations
	clb             = as.numeric(c("0.01", "0.01", "0.01"))
	cub             = as.numeric(c("5.00", "5.00", "5.00"))
	vecs_out[1:globalveclen]        = -1.99
	theta_out[1:3]                  = -1.99
	#Initiate exageostat instance
	rexageostat_initR(ncores, gpus, ts)
	#Generate Z observation vector
	vecs_out        = rexageostat_gen_zR(n, ncores, gpus, ts, p_grid, q_grid, theta1, theta2, theta3, computation, dmetric, globalveclen)
	#Estimate MLE parameters
	theta_out       = rexageostat_likelihoodR(n, ncores, gpus, ts, p_grid, q_grid,  vecs_out[1:n],  vecs_out[n+1:(2*n)],  vecs_out[(2*n+1):(3*n)], clb, cub, computation, dmetric)
	#finalize exageostat instance
	rexageostat_finalizeR()
	print("Back from exageostat_gen_z! hit key...")
	browser()
}

exageostat_gen_zR <- function(n, ncores, gpus, ts, p_grid, q_grid, theta1, theta2, theta3, computation, dmetric, globalveclen)
{
	globalvec= vector (mode="numeric", length = globalveclen)
	globalvec2 = .C("rexageostat_gen_z",
			as.integer(n),
                	as.integer(ncores),
	                as.integer(gpus),
        	        as.integer(ts),
                	as.integer(p_grid),
	                as.integer(q_grid),
        	        as.numeric(theta1),
			as.numeric(theta2),
			as.numeric(theta3),
        	        as.integer(computation),		
                	as.integer(dmetric),
	                as.integer(globalveclen),		
			globalvec = numeric(globalveclen))$globalvec

	globalvec[1:globalveclen] <- globalvec2[1:globalveclen]
	print("back from exageostat_gen_z C function call. Hit key....")
	return(globalvec)
}


exageostat_likelihoodR <- function(n, ncores, gpus, ts, p_grid, q_grid, x, y, z, clb, cub, computation, dmetric)
{
	theta_out2= .C("rexageostat_likelihood",
	                as.integer(n),
	                as.integer(ncores),
	                as.integer(gpus),
	                as.integer(ts),
	                as.integer(p_grid),
	                as.integer(q_grid),
			as.numeric(x),
			as.integer((n)),
			as.numeric(y),
			as.integer((n)),
			as.numeric(z),
	                as.integer((n))	,	
	                as.numeric(clb),
	                as.integer((3)),	
			as.numeric(cub),
	                as.integer((3)),
			as.integer(computation),
	                as.integer(dmetric),
			theta_out=numeric(3))$theta_out		
	theta_out[1:3] <- theta_out2[1:3]
	print("back from exageostat_likelihood C function call. Hit key....")
	return(theta_out)
}

exageostat_initR <- function(ncores, gpus, ts)
{
	#install.packages(repos="https://cran.r-project.org", "RhpcBLASctl")
        library(RhpcBLASctl)
	blas_get_num_procs()
	blas_set_num_threads(1)
	omp_set_num_threads(1)
	.C("rexageostat_init",
            as.integer(ncores),
            as.integer(gpus),
            as.integer(ts))
	print("back from exageostat_init C function call. Hit key....")
}

exageostat_finalizeR <- function()
{
	.C("rexageostat_finalize")
	print("back from exageostat_finalize C function call. Hit key....")
}


