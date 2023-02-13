#
# Copyright (c) 2017-2023, King Abdullah University of Science and Technology
# All rights reserved.
#
# ExaGeoStat-R is a software package provided by KAUST
#
#
#
# @file test-assessment-MSLER.R
# ExaGeoStat R test example
#
# @version 1.2.0
#
# @author Faten Alamri & Sameh Abdulah
# @date 2021-12-13

library("exageostatr")                                # Load ExaGeoStat-R lib.
x    <- c(1:16)  
y    <- c(5:20)                                       # Vector representing  number of true values.
ypre <- predict(lm(y ~ x))                            # Vector denoting values of number of y predicted values.

# Assessment function 
result = mean_squared_logarithmic_error(y, ypre)

print(x)
print(y)
print(result)
