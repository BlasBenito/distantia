#ifndef PSI_H
#define PSI_H

#include <Rcpp.h>

// Forward declarations of functions

Rcpp::DataFrame psi_cost_path_cpp(
    Rcpp::NumericMatrix a,
    Rcpp::NumericMatrix b,
    const std::string& distance = "euclidean",
    bool diagonal = false,
    bool weighted = false,
    bool ignore_blocks = false
);

double psi_auto_sum_cpp(
    Rcpp::NumericMatrix a,
    Rcpp::NumericMatrix b,
    Rcpp::DataFrame path,
    const std::string& distance = "euclidean",
    bool ignore_blocks = false
);

double psi_formula_cpp(
    Rcpp::DataFrame path,
    double auto_sum,
    bool diagonal = false
);

double psi_paired_cpp(
    Rcpp::NumericMatrix a,
    Rcpp::NumericMatrix b,
    const std::string& distance = "euclidean"
);

Rcpp::NumericVector null_psi_paired_cpp(
    Rcpp::NumericMatrix a,
    Rcpp::NumericMatrix b,
    const std::string& distance = "euclidean",
    Rcpp::IntegerVector block_size = Rcpp::IntegerVector::create(2, 3, 4),
    int seed = 1,
    bool independent_columns = true,
    int repetitions = 100
);

double psi_cpp(
    Rcpp::NumericMatrix a,
    Rcpp::NumericMatrix b,
    const std::string& distance = "euclidean",
    bool diagonal = false,
    bool weighted = false,
    bool ignore_blocks = false
);

Rcpp::NumericVector null_psi_cpp(
    Rcpp::NumericMatrix a,
    Rcpp::NumericMatrix b,
    const std::string& distance = "euclidean",
    bool diagonal = false,
    bool weighted = false,
    bool ignore_blocks = false,
    Rcpp::IntegerVector block_size = Rcpp::IntegerVector::create(2, 3, 4),
    int seed = 1,
    bool independent_columns = true,
    int repetitions = 100
);

#endif  // PSI_H
