#ifndef DISTANCE_MATRIX_CPP_H
#define DISTANCE_MATRIX_CPP_H

#include <Rcpp.h>
#include "distance_metrics.h"

Rcpp::NumericMatrix distance_matrix_cpp(
    Rcpp::NumericMatrix a,
    Rcpp::NumericMatrix b,
    Rcpp::Nullable<std::string> method
);

Rcpp::NumericVector distance_pairwise_cpp(
    Rcpp::NumericMatrix a,
    Rcpp::NumericMatrix b,
    Rcpp::Nullable<std::string> method
);

#endif // DISTANCE_MATRIX_CPP_H

