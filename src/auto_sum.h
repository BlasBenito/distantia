#ifndef AUTO_SUM_H
#define AUTO_SUM_H

#include <Rcpp.h>

// Distance matrix function declaration
double auto_distance_cpp(
    Rcpp::NumericMatrix m,
    Rcpp::Nullable<std::string> method
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
    Rcpp::Nullable<std::string> method
);

double auto_sum_no_path_cpp(
        Rcpp::NumericMatrix a,
        Rcpp::NumericMatrix b,
        Rcpp::Nullable<std::string> method
);

#endif // AUTO_SUM_H
