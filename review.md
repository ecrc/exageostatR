1- The package is only available for Linux/MacOS, which misses a significant number of Windows users. Is there any chance to port the package to Windows? The reasoning why the package is not available on Windows should be explained.   (Sameh)

2-The whole code of the package wraps calls to C library without doing much else. The functions should at least check input values for types and output error messages directly from R. Right now the functions will fail on conversions inside C functions call (i.e. as.integer() in .C() call). The produced error will not be very helpful for users. Package "assertthat" could be helpful authors there. (Jian)

3-Functions Test1, Test2 and Test3 should not be exported like this. These are examples, not package functions. These should be used as examples in the documentation or in vignettes. (Jian) 


The code of the package should be divided into separate R files for each function of the package.
The functions in R generally use descriptive values for parameters instead of integers values. I.e. in function "simulate_data_exact" the parameter "dmetric" should use values like "euclidean" and "great circle" instead of 0 and 1. The goal is to make it as readable for users as possible. The good example can be found in function "cov" of base R as parameter "method = c("pearson", "kendall", "spearman")". (Yuxaio)



The documentation of the package/individual functions is rather brief. The documentation for R functions is generally more descriptive and includes examples.

The files listed under tests folder are not tests but examples. The package should definitely include some tests, but those have to be tests in the proper sense. The general suggestion is to use "testthat" package. (More discussion)

I would suggest styling the package code using "styler" package. 
The package does not adhere to general suggestions regarding R code specified in neither "R packages" (http://r-pkgs.had.co.nz/) nor "Writing R Extensions" (https://cran.r-project.org/doc/manuals/r-release/R-exts.html). (Yuxiao)


Add more analysis functions (ploting, ...etc)   (Yuxiao/Jian)