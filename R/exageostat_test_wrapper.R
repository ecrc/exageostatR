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
 # @version 0.1.1
 #
 # @author Sameh Abdulah
 # @date 2018-07-04
 
  
Test1 <- function()
# Test Generating Z vector using random (x, y) locations with exact MLE computation.
{
	library("exageostat")						#Load ExaGeoStat-R lib.
	seed		= 0						#Initial seed to generate XY locs.
	theta1          = 1						#Initial variance.
	theta2          = 0.1                                   	#Initial smoothness.
	theta3          = 0.5                                   	#Initial range.
	dmetric         = 0                                     	#0 --> Euclidean distance, 1--> great circle distance.
	n               = 1600                                 		#n*n locations grid.
	ncores          = 2                                     	#Number of underlying CPUs.
	gpus            = 0                                     	#Number of underlying GPUs.
	ts              = 320                                   	#Tile_size:  changing it can improve the performance. No fixed value can be given.
	p_grid          = 1                                     	#More than 1 in the case of distributed systems
	q_grid          = 1                                     	#More than 1 in the case of distributed systems ( usually equals to p_grid)
	clb             = vector(mode="double",length = 3)     	#Optimization function lower bounds values.
	cub             = vector(mode="double",length = 3)     	#Optimization function upper bounds values.
	theta_out       = vector(mode="double",length = 3)     	#Parameter vector output.
	globalveclen    = 3*n
	vecs_out        = vector(mode="double",length = globalveclen)  #Z measurements of n locations
	clb             = as.double(c("0.01", "0.01", "0.01"))		#Optimization lower bounds.
	cub             = as.double(c("5.00", "5.00", "5.00"))		#Optimization upper bounds.
	vecs_out[1:globalveclen]        = -1.99
	theta_out[1:3]                  = -1.99
	#Initiate exageostat instance
	exageostat_initR(ncores, gpus, ts)
	#Generate Z observation vector
	vecs_out        = exageostat_egenzR(n, ncores, gpus, ts, p_grid, q_grid, theta1, theta2, theta3, dmetric, seed, globalveclen)
	#Estimate MLE parameters (Exact)
	theta_out       = mle_exact(n, ncores, gpus, ts, p_grid, q_grid,  vecs_out[1:n],  vecs_out[n+1:(2*n)],  vecs_out[(2*n+1):(3*n)], clb, cub, dmetric, 0.0001, 20)
	#Finalize exageostat instance
	exageostat_finalizeR()
	browser()
}

Test2 <- function()
# Test Generating Z vector using random (x, y) locations with TLR MLE computation.
{
        library("exageostat")		                                #Load ExaGeoStat-R lib.
        seed            = 0                                             #Initial seed to generate XY locs.
        theta1          = 1             		                #Initial variance.
        theta2          = 0.03						#Initial smoothness.
        theta3          = 0.5                                  		#Initial range.
        dmetric         = 0                                     	#0 --> Euclidean distance, 1--> great circle distance.
        n               = 900                                   	#n*n locations grid.
        ncores          = 4                                     	#Number of underlying CPUs.
        gpus            = 0                                     	#Number of underlying GPUs.
        dts             = 320                                           #Tile_size:  changing it can improve the performance. No fixed value can be given.
        lts             = 600                                   	#TLR_Tile_size:  changing it can improve the performance. No fixed value can be given.
        p_grid          = 1                                     	#More than 1 in the case of distributed systems.
        q_grid          = 1                                     	#More than 1 in the case of distributed systems ( usually equals to p_grid).
        clb             = vector(mode="double", length = 3)    	#Optimization function lower bounds values.
        cub             = vector(mode="double", length = 3)   		#Optimization function upper bounds values.
        theta_out       = vector(mode="double", length = 3)    	#Parameter vector output.
        globalveclen    = 3*n
        vecs_out        = vector(mode="double", length = globalveclen) #Z measurements of n locations.
        clb             = as.double(c("0.01", "0.01", "0.01"))		#Optimization lower bounds.
        cub             = as.double(c("5.00", "5.00", "5.00"))         #Optimization upper bounds.
	tlr_acc		= 7						#Approximation accuracy 10^-(acc)
	tlr_maxrank	= 450						#Max Rank
        vecs_out[1:globalveclen]        = -1.99
        theta_out[1:3]                  = -1.99
        #Initiate exageostat instance
        exageostat_initR(ncores, gpus, dts)
        #Generate Z observation vector
        vecs_out        = exageostat_egenzR(n, ncores, gpus, dts, p_grid, q_grid, theta1, theta2, theta3, dmetric, seed, globalveclen)
        #Estimate MLE parameters (TLR approximation)
        theta_out       = exageostat_tlrmleR(n, ncores, gpus, lts, p_grid, q_grid,  vecs_out[1:n],  vecs_out[n+1:(2*n)],  vecs_out[(2*n+1):(3*n)], clb, cub, tlr_acc, tlr_maxrank,  dmetric, 0.0001, 20)
        #Finalize exageostat instance
        exageostat_finalizeR()
        browser()
}


Test3 <- function()
# Test Generating Z vector using random (x, y) locations with DST MLE computation.
{
        library("exageostat")                                           #Load ExaGeoStat-R lib.
        seed            = 0                                             #Initial seed to generate XY locs.
        theta1          = 1                                             #Initial variance.
        theta2          = 0.03                                          #Initial smoothness.
        theta3          = 0.5                                           #Initial range.
        dmetric         = 0                                             #0 --> Euclidean distance, 1--> great circle distance.
        n               = 900                                           #n*n locations grid.
        ncores          = 4                                             #Number of underlying CPUs.
        gpus            = 0                                             #Number of underlying GPUs.
        ts             = 320                                            #Tile_size:  changing it can improve the performance. No fixed value can be given.
        p_grid          = 1                                             #More than 1 in the case of distributed systems.
        q_grid          = 1                                             #More than 1 in the case of distributed systems ( usually equals to p_grid).
        clb             = vector(mode="double", length = 3)            #Optimization function lower bounds values.
        cub             = vector(mode="double", length = 3)            #Optimization function upper bounds values.
        theta_out       = vector(mode="double", length = 3)            #Parameter vector output.
        globalveclen    = 3*n
        vecs_out        = vector(mode="double", length = globalveclen) #Z measurements of n locations.
        clb             = as.double(c("0.01", "0.01", "0.01"))         #Optimization lower bounds.
        cub             = as.double(c("5.00", "5.00", "5.00"))         #Optimization upper bounds.
        dst_thick       = 3                                             #Number of used Diagonal Super Tile (DST).
        vecs_out[1:globalveclen]        = -1.99
        theta_out[1:3]                  = -1.99
        #Initiate exageostat instance
        exageostat_initR(ncores, gpus, ts)
        #Generate Z observation vector
        vecs_out        = exageostat_egenzR(n, ncores, gpus, ts, p_grid, q_grid, theta1, theta2, theta3, dmetric, seed, globalveclen)
        #Estimate MLE parameters (DST approximation)
        theta_out       = exageostat_dstmleR(n, ncores, gpus, ts, p_grid, q_grid,  vecs_out[1:n],  vecs_out[n+1:(2*n)],  vecs_out[(2*n+1):(3*n)], clb, cub, dst_thick,  dmetric, 0.0001, 20)
        #Finalize exageostat instance
        exageostat_finalizeR()
        browser()
}

Test4 <- function()
# Test Generating Z vector using given (x, y) locations with exact MLE computation.
{
        library("exageostat")                                       		#Load ExaGeoStat-R lib.
        theta1          = 1                                            		#Initial variance.
        theta2          = 0.1                                           	#Initial smoothness.
        theta3          = 0.5                                           	#Initial range.
        dmetric         = 0                                            		#0 --> Euclidean distance, 1--> great circle distance.
        n               = 1600                                          	#n*n locations grid.
        ncores          = 2                                             	#Number of underlying CPUs.
        gpus            = 0                                             	#Number of underlying GPUs.
        ts              = 320                                           	#Tile_size:  changing it can improve the performance. No fixed value can be given.
        p_grid          = 1                                             	#More than 1 in the case of distributed systems
        q_grid          = 1                                             	#More than 1 in the case of distributed systems ( usually equals to p_grid)
        clb             = vector(mode="double",length = 3)             	#Optimization function lower bounds values.
        cub             = vector(mode="double",length = 3)             	#Optimization function upper bounds values.
        theta_out       = vector(mode="double",length = 3)             	#Parameter vector output.
        globalveclen    = n
        vecs_out        = vector(mode="double",length = globalveclen)  	#Z measurements of n locations.
        x	        = rnorm(n = globalveclen, mean = 39.74, sd = 25.09)	#x measurements of n locations.
        y       	= rnorm(n = globalveclen, mean = 80.45, sd = 100.19)	#y measurements of n locations.
        clb             = as.double(c("0.01", "0.01", "0.01"))        		#Optimization lower bounds.
        cub             = as.double(c("5.00", "5.00", "5.00"))        		#Optimization upper bounds.
        vecs_out[1:globalveclen]        = -1.99
        theta_out[1:3]                  = -1.99
        #Initiate exageostat instance
        exageostat_initR(ncores, gpus, ts)
        #Generate Z observation vector based on given locations
        vecs_out        = exageostat_egenz_glR(n, ncores, gpus, ts, p_grid, q_grid, x, y, theta1, theta2, theta3, dmetric, globalveclen)
        #Estimate MLE parameters (Exact)
        theta_out       = exageostat_emleR(n, ncores, gpus, ts, p_grid, q_grid,  x,  y,  vecs_out, clb, cub, dmetric, 0.0001, 20)
        #Finalize exageostat instance
        exageostat_finalizeR()
        browser()
}

exageostat_egenzR <- function(n, ncores, gpus, ts, p_grid, q_grid, theta1, theta2, theta3, dmetric, seed, globalveclen)
{
	globalvec  = vector (mode="double", length = globalveclen)
	globalvec2 = .C("gen_z_exact",
			as.integer(n),
                	as.integer(ncores),
	                as.integer(gpus),
        	        as.integer(ts),
                	as.integer(p_grid),
	                as.integer(q_grid),
        	        as.double(theta1),
			as.double(theta2),
			as.double(theta3),
                	as.integer(dmetric),
			as.integer(seed),
	                as.integer(globalveclen),		
			globalvec = double(globalveclen))$globalvec

	globalvec[1:globalveclen] <- globalvec2[1:globalveclen]
	print("back from gen_z_exact  C function call. Hit key....")
	return(globalvec)
}


exageostat_egenz_glR <- function(n, ncores, gpus, ts, p_grid, q_grid, x, y, theta1, theta2, theta3, dmetric,  globalveclen)
{
        globalvec  = vector (mode="double", length = globalveclen)
        globalvec2 = .C("gen_z_givenlocs_exact",
			as.integer(n),
                        as.integer(ncores),
                        as.integer(gpus),
                        as.integer(ts),
                        as.integer(p_grid),
                        as.integer(q_grid),
                        as.double(x),
                        as.integer((n)),
                        as.double(y),
                        as.integer((n)),
                        as.double(theta1),
                        as.double(theta2),
                        as.double(theta3),
                        as.integer(dmetric),
                        as.integer(globalveclen),
                        globalvec = double(globalveclen))$globalvec
        globalvec[1:globalveclen] <- globalvec2[1:globalveclen]
        print("back from gen_z_givenlocs_exact  C function call. Hit key....")
        return(globalvec)
}


exageostat_emleR <- function(n, ncores, gpus, ts, p_grid, q_grid, x, y, z, clb, cub, dmetric, opt_tol, opt_max_iters)
{
	theta_out2 = .C("mle_exact",
	                as.integer(n),
	                as.integer(ncores),
	                as.integer(gpus),
	                as.integer(ts),
	                as.integer(p_grid),
	                as.integer(q_grid),
			as.double(x),
			as.integer((n)),
			as.double(y),
			as.integer((n)),
			as.double(z),
	                as.integer((n))	,	
	                as.double(clb),
	                as.integer((3)),	
			as.double(cub),
	                as.integer((3)),
	                as.integer(dmetric),
                        as.double(opt_tol),
                        as.integer(opt_max_iters),
			theta_out=double(3))$theta_out		
	theta_out[1:3] <- theta_out2[1:3]
	print("back from mle_exact C function call. Hit key....")
	return(theta_out)
}

exageostat_tlrmleR <- function(n, ncores, gpus, ts, p_grid, q_grid, x, y, z, clb, cub, tlr_acc, tlr_maxrank, dmetric, opt_tol, opt_max_iters)
{
        theta_out2 = .C("mle_tlr",
                        as.integer(n),
                        as.integer(ncores),
                        as.integer(gpus),
                        as.integer(ts),
                        as.integer(p_grid),
                        as.integer(q_grid),
                        as.double(x),
                        as.integer((n)),
                        as.double(y),
                        as.integer((n)),
                        as.double(z),
                        as.integer((n)) ,
                        as.double(clb),
                        as.integer((3)),
                        as.double(cub),
                        as.integer((3)),
                        as.integer(tlr_acc),
                        as.integer(tlr_maxrank),
                        as.integer(dmetric),
                        as.double(opt_tol),
                        as.integer(opt_max_iters),
                        theta_out=double(3))$theta_out
        theta_out[1:3] <- theta_out2[1:3]
        print("back from mle_tlr C function call. Hit key....")
        return(theta_out)
}


exageostat_dstmleR <- function(n, ncores, gpus, ts, p_grid, q_grid, x, y, z, clb, cub, dst_thick, dmetric, opt_tol, opt_max_iters)
{
        theta_out2 = .C("mle_dst",
                        as.integer(n),
                        as.integer(ncores),
                        as.integer(gpus),
                        as.integer(ts),
                        as.integer(p_grid),
                        as.integer(q_grid),
                        as.double(x),
                        as.integer((n)),
                        as.double(y),
                        as.integer((n)),
                        as.double(z),
                        as.integer((n)) ,
                        as.double(clb),
                        as.integer((3)),
                        as.double(cub),
                        as.integer((3)),
                        as.integer(dst_thick),
                        as.integer(dmetric),
                        as.double(opt_tol),
                        as.integer(opt_max_iters),
                        theta_out=double(3))$theta_out
        theta_out[1:3] <- theta_out2[1:3]
        print("back from mle_dst C function call. Hit key....")
        return(theta_out)
}




exageostat_initR <- function(ncores, gpus, ts)
{
        library("parallel")
	Sys.setenv(OMP_NUM_THREADS=1)
	Sys.setenv(STARPU_WORKERS_NOBIND=1)
	mcaffinity(1:ncores)

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


