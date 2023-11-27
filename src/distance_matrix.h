#ifndef DISTANCE_MATRIX_H
#define DISTANCE_MATRIX_H

#include <Rcpp.h>

Rcpp::NumericMatrix distance_matrix_cpp(Rcpp::NumericMatrix a, Rcpp::NumericMatrix b, Rcpp::Function f);

#endif // DISTANCE_MATRIX_H
