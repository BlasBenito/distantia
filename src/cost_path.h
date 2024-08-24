#ifndef COST_PATH_H
#define COST_PATH_H

#include <Rcpp.h>

Rcpp::DataFrame cost_path_orthogonal_cpp(Rcpp::NumericMatrix dist_matrix, Rcpp::NumericMatrix cost_matrix);
Rcpp::DataFrame cost_path_diagonal_cpp(Rcpp::NumericMatrix dist_matrix, Rcpp::NumericMatrix cost_matrix);
Rcpp::DataFrame cost_path_trim_cpp(Rcpp::DataFrame path);
double cost_path_sum_cpp(Rcpp::DataFrame path);

#endif // COST_PATH_H
