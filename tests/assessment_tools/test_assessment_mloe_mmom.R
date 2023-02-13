#
# Copyright (c) 2017-2023, King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file test-assessment-mloe.R 
# ExaGeoStat R test example
#
# @version 1.2.0
#
# @author Faten Alamri & Sameh Abdulah
# @date 2021-12-3

library("assertthat")

#Load ExaGeoStat-R lib.
library("exageostatr")                                         

seed      = 0                                             # Initial seed to generate XY locs
dmetric   = "euclidean"                                   # 0 --> Euclidean distance and 1--> great circle distance
n         = 900                                           # n*n locations grid
mp_band   = 3  
theta     = c(1, 0.03, 0.5)

# Initiate exageostat instance
exageostat_init(hardware = list (ncores = 4, ngpus = 0, ts = 320, lts = 0,  pgrid = 1, qgrid = 1))

# Generate Z observation vector
data     = simulate_data_exact("ugsm-s", theta, dmetric, n, seed) 
fisher_matrix(list(x = data$x, y = data$y), theta)
k <- 10
N <- 900
unit <- N/k #90

x <- data["x"]
y <- data["y"]
z <- data["z"]

data <- data.frame(x, y, z)

set.seed(12345)  

data <- data[sample(1:nrow(data), N), ]

for (i in 0:(k-1)){

    testing <- data[((unit*i)+1):((i+1)*unit), ]
    if (i== k-1)
        training <- data[0:(unit*i), ]
    else
        training <- rbind(data[0:(unit*i), ], data[(unit*(i+1)):N, ])

    testing_obs  = testing[,3]
    training_obs = training[,3]

    testing_locs  <- cbind(testing[,1], testing[,2])#, testing[,3])
    training_locs <- cbind(training[,1], training[,2])#,  training[,3])

}

x_train = training_locs[, 1]
y_train = training_locs[, 2]
z_train = training_obs
x_test  = testing_locs[, 1]
y_test  = testing_locs[, 2]
z_test  = testing_obs

# Prediction data 
data_predict <- list("x_train" = x_train, "y_train" = y_train, "z_train" = z_train, 
                     "x_test" = x_test, "y_test" = y_test)

data_train <- list ("x_train" = x_train, "y_train" = y_train, "z_train" = z_train)

# Estimate MLE parameters (DST approximation)
result_mle = exact_mle(data_train,"ugsm-s", dmetric, optimization = list(clb = c(0.001, 0.001, 0.001),
                                                                         cub = c(5, 5,5 ), tol = 1e-4, max_iters = 40))

est_theta  = c(result_mle  ["sigma_sq"], result_mle  ["beta"], result_mle  ["nu"])

# Predict using parameters estimate from result
prediction_result = exact_predict(data_predict,"ugsm-s", dmetric,  est_theta, 0)
print(prediction_result)

# Calculate MSPE
mspe1 = mean(as.numeric(z_test -prediction_result)^2)
MSPE <- mean((z_test - prediction_result )^2)

mloe = exact_mloe_mmom(data_predict , "ugsm-s",dmetric,est_theta, theta,  0)

# Finalize exageostat instance
exageostat_finalize()
