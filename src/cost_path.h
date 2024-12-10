#ifndef COST_PATH_H
#define COST_PATH_H

#include <Rcpp.h>

Rcpp::DataFrame cost_path_orthogonal_cpp(
    Rcpp::NumericMatrix dist_matrix,
    Rcpp::NumericMatrix cost_matrix
);

Rcpp::DataFrame cost_path_diagonal_cpp(
    Rcpp::NumericMatrix dist_matrix,
    Rcpp::NumericMatrix cost_matrix
);

Rcpp::DataFrame cost_path_orthogonal_itakura_cpp(
        Rcpp::NumericMatrix dist_matrix,
        Rcpp::NumericMatrix cost_matrix,
        double bandwidth = 0.25
);

Rcpp::DataFrame cost_path_diagonal_itakura_cpp(
        Rcpp::NumericMatrix dist_matrix,
        Rcpp::NumericMatrix cost_matrix,
        double bandwidth = 0.25
);

Rcpp::DataFrame cost_path_trim_cpp(
    Rcpp::DataFrame path
);

double cost_path_sum_cpp(Rcpp::DataFrame path);

Rcpp::DataFrame cost_path_cpp(
    Rcpp::NumericMatrix a,
    Rcpp::NumericMatrix b,
    const std::string& distance = "euclidean",
    bool diagonal = false,
    bool weighted = false,
    bool ignore_blocks = false,
    double bandwidth = 1
);

#endif // COST_PATH_H
