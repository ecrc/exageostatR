# @file test1-Faten.R
# ExaGeoStat R wrapper test example
#
# @version 1.2.0
#
# @author Faten Alamri
# @date 2021-1-26

library("assertthat")
library("exageostatr")                                          # Load ExaGeoStat-R lib.
#setwd("../data/900_100")

dmetric         = "euclidean"                                   # 0 --> Euclidean distance, 1--> great circle distance.
tlr_acc         = 7                                             # Approximation accuracy 10^-(acc)
tlr_maxrank     = 450                                           # Max Rank

load(file="../../data/900_100/XYZ_100k_15_0017526_23.rda")

data=list("x"=as.numeric(Datasets1b$x), "y"=as.numeric(Datasets1b$y),
	  "z"=as.numeric(Datasets1b$Measure))                                       # Convert data for input
# Initiate exageostat instance
exageostat_init(hardware = list (ncores = 2, ngpus = 0, ts = 320, lts = 600,  pgrid = 1, qgrid = 1))

# Estimate MLE parameters with tile low rank method
result       = tlr_mle(data, "ugsm-s", tlr_acc, tlr_maxrank,  dmetric, optimization = 
		       list(clb = c(0.001, 0.001, 0.001), cub = c(5, 5, 5 ), tol = 1e-4, max_iters = 13))
print(result)

#Finalize exageostat instance
exageostat_finalize()
