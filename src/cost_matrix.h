#ifndef COST_MATRIX_H
#define COST_MATRIX_H

#include <Rcpp.h>

Rcpp::NumericMatrix cost_matrix_diagonal_cpp(Rcpp::NumericMatrix dist_matrix);
Rcpp::NumericMatrix cost_matrix_diagonal_weighted_cpp(Rcpp::NumericMatrix dist_matrix);
Rcpp::NumericMatrix cost_matrix_orthogonal_cpp(Rcpp::NumericMatrix dist_matrix);

#endif // COST_MATRIX_H
