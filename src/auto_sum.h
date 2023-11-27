#ifndef AUTO_SUM_H
#define AUTO_SUM_H

#include <Rcpp.h>

double auto_distance_cpp(Rcpp::NumericMatrix m, Rcpp::Function f);
Rcpp::NumericMatrix subset_matrix_by_rows_cpp(Rcpp::NumericMatrix m, Rcpp::NumericVector rows);
double auto_sum_cpp(Rcpp::NumericMatrix a, Rcpp::NumericMatrix b, Rcpp::DataFrame path, Rcpp::Function f);

#endif // AUTO_SUM_H
