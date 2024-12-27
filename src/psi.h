#ifndef PSI_H
#define PSI_H

#include <Rcpp.h>

// Forward declarations of functions

double psi_equation_cpp(
    double cost_path_sum,
    double auto_sum,
    bool diagonal = false
);

double psi_ls_cpp(
    Rcpp::NumericMatrix a,
    Rcpp::NumericMatrix b,
    const std::string& distance = "euclidean"
);

Rcpp::NumericVector psi_null_ls_cpp(
    Rcpp::NumericMatrix a,
    Rcpp::NumericMatrix b,
    const std::string& distance = "euclidean",
    Rcpp::IntegerVector block_size = Rcpp::IntegerVector::create(2, 3, 4),
    int seed = 1,
    bool independent_columns = true,
    int repetitions = 100
);

double psi_dtw_cpp(
    Rcpp::NumericMatrix a,
    Rcpp::NumericMatrix b,
    const std::string& distance = "euclidean",
    bool diagonal = false,
    bool weighted = false,
    bool ignore_blocks = false,
    double bandwidth = 1
);

Rcpp::NumericVector psi_null_dtw_cpp(
    Rcpp::NumericMatrix a,
    Rcpp::NumericMatrix b,
    const std::string& distance = "euclidean",
    bool diagonal = true,
    bool weighted = true,
    bool ignore_blocks = false,
    double bandwidth = 1,
    Rcpp::IntegerVector block_size = Rcpp::IntegerVector::create(2, 3, 4),
    int seed = 1,
    bool independent_columns = true,
    int repetitions = 100
);

#endif  // PSI_H
