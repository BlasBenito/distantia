#ifndef COST_MATRIX_H
#define COST_MATRIX_H

#include <Rcpp.h>

Rcpp::NumericMatrix cost_matrix_diag_cpp(Rcpp::NumericMatrix dist_matrix);
Rcpp::NumericMatrix cost_matrix_weighted_diag_cpp(Rcpp::NumericMatrix dist_matrix);
Rcpp::NumericMatrix cost_matrix_cpp(Rcpp::NumericMatrix dist_matrix);

#endif // COST_MATRIX_H
