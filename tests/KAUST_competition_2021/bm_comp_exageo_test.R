#
#
# Copyright (c) 2017-2023 King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file bm_comp.R
# ExaGeoStat R wrapper functions
#
# @version 1.2.0
#
# @author Faten Alamri & Sameh Abdulah
# @date 2021-10-27

#################################################
##                 ExaGeoStatR
#################################################
library(assertthat)
library(exageostatr)


####### ExaGeoStatR
Exageostat_modeling_predicting<-function(Data_train_list, Data_predict_list)
{
	dmetric = "euclidean"
	exageostat_init(hardware =   list (ncores = 31 , ngpus = 0, ts = 320, lts = 0 , pgrid = 4, qgrid = 4)) #Initiate exageostat instance.

	print("modeling should start")
	result_mle  = exact_mle(Data_train_list,"ugsm-s", dmetric,
				optimization = list(clb = c(0.001, 0.001, 0.001),
						    cub = c(5, 5,5 ), tol = 1e-7, max_iters = 4000))
	est_theta<-c(result_mle  ["sigma_sq"], result_mle  ["beta"],
		     result_mle  ["nu"])

	#### predict on omitted data
	prediction_result <- exact_predict(Data_train_list, Data_predict_list,"ugsm-s",  dmetric, est_theta, 0)

	theta_out= c(result_mle$sigma, result_mle$beta, 0, result_mle$nu)

	exageostat_finalize() #Finalize exageostat instance.
	return(list(theta = theta_out, z_out = prediction_result))

}

# Different theta vectors

load(file = "../../data/90_10/XYZ_90K_15_0017526_23_1.rda")
Data_train <- as.data.frame( Datasets9)
load(file = "../../data/90_10/XYZ_10K_15_0017526_23_1.rda")
Data_test <- as.data.frame( Datasets)

Data_train_list <- list("x" = Data_train$x, "y" = Data_train$y, "z" = Data_train$Measure )
Data_predict_list <- list("x" = Data_test$x, "y" =Data_test$y)

BM_out <- bm_comp(FUN = Exageostat_modeling_predicting, Data_train_list, Data_predict_list)
BM_out
