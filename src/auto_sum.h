#ifndef AUTO_SUM_H
#define AUTO_SUM_H

#include <Rcpp.h>

// Distance matrix function declaration
double auto_distance_cpp(
    Rcpp::NumericMatrix m,
    const std::string& distance = "euclidean"
);

// Subset matrix by rows function declaration
Rcpp::NumericMatrix subset_matrix_by_rows_cpp(
    Rcpp::NumericMatrix m,
    Rcpp::NumericVector rows
);

// Auto-sum function declaration
double auto_sum_path_cpp(
    Rcpp::NumericMatrix a,
    Rcpp::NumericMatrix b,
    Rcpp::DataFrame path,
    const std::string& distance = "euclidean"
);

double auto_sum_cpp(
        Rcpp::NumericMatrix a,
        Rcpp::NumericMatrix b,
        const std::string& distance = "euclidean"
);

#endif // AUTO_SUM_H
