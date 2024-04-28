#ifndef DISTANCE_MATRIX_CPP_H
#define DISTANCE_MATRIX_CPP_H

#include <Rcpp.h>
#include "distance_methods.h"

Rcpp::NumericMatrix distance_matrix_cpp(
    Rcpp::NumericMatrix a,
    Rcpp::NumericMatrix b,
    const std::string& distance = "euclidean"
);

double distance_lock_step_cpp(
    Rcpp::NumericMatrix a,
    Rcpp::NumericMatrix b,
    const std::string& distance = "euclidean"
);

#endif // DISTANCE_MATRIX_CPP_H

