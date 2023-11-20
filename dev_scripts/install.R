library(Rcpp)
library(devtools)

Rcpp::compileAttributes()
devtools::document()
devtools::install()
library(distantia)
